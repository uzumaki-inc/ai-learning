# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Course < ApplicationRecord
  include ActionView::RecordIdentifier
  has_many :chapters, dependent: :destroy
  has_many :topics, through: :chapters

  validates :title, presence: true

  def progress_percentage(user)
    return 0 if user.nil?
    return 0 if user.user_topic_progresses.empty?
    return 0 if topics.empty?
    ((user.user_topic_progresses.status_completed.joins(topic: :chapter).where(chapter: { course_id: id }).count.to_f / topics.count.to_f) * 100).to_i
  end

  def create_chapter_and_topics
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini", # Required.
        messages: [
          { role: "system", content: "あなたはeラーニングの学習コンテンツ制作者です。" },
          { role: "user", content: "「#{title}」とう分野に関する学習コンテンツを日本語で作成してください。chapterは3種類くらいでそのchapterの中にtopicを5種類くらい作りたいです。また、questionには質問内容を、model_answerには模範回答を設定するようにしてください。" }
        ],
        temperature: 1.0,
        tools: [
          {
            type: "function",
            function: {
              name: "generate_e_learning_contents",
              description: "学習コンテンツを作成する",
              parameters: {
                type: "object",
                properties: {
                  learning_contents: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        chapter: { type: "string" },
                        topic: { type: "string" },
                        question: { type: "string" },
                        model_answer: { type: "string" }
                      },
                      required: ["chapter", "topic", "question", "model_answer"]
                    }
                  }
                },
                required: ["learning_contents"]
              }
            }
          }
        ],
        # Optional, defaults to "auto"
        # Can also put "none" or specific functions, see docs
        tool_choice: "required"
      }
    )
    message = response.dig("choices", 0, "message")

    if message["role"] == "assistant" && message["tool_calls"]
      message["tool_calls"].each do |tool_call|
        function_name = tool_call.dig("function", "name")
        function_args = JSON.parse(
          tool_call.dig("function", "arguments"),
          { symbolize_names: true },
          )
        case function_name
        when "generate_e_learning_contents"
          generate_e_learning_contents(**function_args)
        else
          # decide how to handle
        end
      end
    end
  end

  def generate_e_learning_contents(arguments)
    arguments[:learning_contents].each do |learning_content|
      chapter = Chapter.find_or_create_by(title: learning_content[:chapter], course: self)
      topic = Topic.create(title: learning_content[:topic], question: learning_content[:question], model_answer: learning_content[:model_answer], chapter: chapter)
      topic.create_open_ai_assistant
    end
  end

  def broadcast_contents_created(user_id:)
    broadcast_replace_later_to(
      dom_id(self),
      partial: "courses/chapter_list",
      locals: { chapters: chapters.order(position: :asc).to_a, user: User.find(user_id) },
      target: "chapter_list"
    )
  end
end
