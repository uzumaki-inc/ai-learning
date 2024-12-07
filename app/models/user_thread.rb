# == Schema Information
#
# Table name: user_threads
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  topic_id              :integer          not null
#  thread_identifier     :string
#  latest_run_identifier :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  notebook_status       :integer
#
# Indexes
#
#  index_user_threads_on_topic_id  (topic_id)
#  index_user_threads_on_user_id   (user_id)
#

class UserThread < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user
  belongs_to :topic
  has_one :user_thread_progress, dependent: :destroy
  has_many :messages, dependent: :destroy
  enum :status, { unprocessed: 0, queued: 1, in_progress: 2, cancelling: 3, completed: 4, requires_action: 5, cancelled: 6, failed: 7, expired: 8 }, prefix: true, validate: true
  enum :notebook_status, { in_progress: 0, completed: 1 }, prefix: true, validate: true, default: :completed


  def broadcast_notebook_created
    broadcast_replace_later_to(
      dom_id(self),
      partial: "user_threads/notebook_list",
      locals: {
        notebooks: Notebook.where(topic:, user:).order(created_at: :asc).to_a,
        user_thread: self
      },
      target: "notebook_list"
    )
  end

  def create_notebooks
    message_histories = messages.order(created_at: :asc)
    message_history_array = message_histories.map do |message|
      { role: message.sender_type, content: message.content }
    end
    # message_history_array.pop
    message_history_array << { role: "user", content: "「#{topic.chapter.course.title}」「#{topic.chapter.title}」「#{topic.title}」というコンテキストにおいて、上記のやりとりからユーザーの理解度があいまいな点を整理して列挙してください。" }
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    response = client.chat(
      parameters: {
        model: "gpt-4o", # Required.
        messages: message_history_array,
        temperature: 1.0,
        tools: [
          {
            type: "function",
            function: {
              name: "generate_learning_note",
              description: "Generate a learning note based on the user's weak areas.",
              parameters: {
                type: "object",
                properties: {
                  learning_notes: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        topic: { type: "string" },
                        model_answer: { type: "string" }
                      },
                      required: ["topic", "model_answer"]
                    }
                  }
                },
                required: ["learning_notes"]
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
        tool_call_id = tool_call.dig("id")
        function_name = tool_call.dig("function", "name")
        function_args = JSON.parse(
          tool_call.dig("function", "arguments"),
          { symbolize_names: true },
          )
        function_response =
          case function_name
          when "generate_learning_note"
            generate_learning_note(**function_args)  # => "The weather is nice 🌞"
          else
            # decide how to handle
          end
      end
    end
  end

  private

  def generate_learning_note(arguments)
    learning_notes = arguments[:learning_notes]
    learning_notes.each do |learning_note|
      title = learning_note[:topic]
      model_answer = learning_note[:model_answer]
      Notebook.find_or_create_by(title:, user_id:, topic_id:) do |notebook|
        notebook.content = model_answer
      end
    end
  end
end
