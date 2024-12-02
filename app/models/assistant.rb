# == Schema Information
#
# Table name: assistants
#
#  id                   :integer          not null, primary key
#  assistant_identifier :string
#  topic_id             :integer          not null
#  type                 :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_assistants_on_topic_id  (topic_id)
#

class Assistant < ApplicationRecord
  belongs_to :topic
  after_destroy :delete_open_ai_assistant

  def self.create_open_ai_assistant(topic)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    env_name = Rails.env.production? ? "(prod)" : "(dev)"
    response = client.assistants.create(
      parameters: {
        model: "gpt-4o",
        name: "#{env_name}#{topic.title}",
        description: nil,
        instructions: instruction_template_text(topic),
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
                        model_answer: { type: "string" },
                      },
                      required: ["topic", "model_answer"],
                   }
                  }
                },
                required: ["learning_notes"]
              },
            },
          },
        ]
      })
    assistant_id = response["id"]
    Assistant.create!(assistant_identifier: assistant_id, topic_id: topic.id)
    sleep 0.1
  end

  def self.instruction_template_text(topic)
    course_title = topic.chapter.course.title
    chapter_title = topic.chapter.title
    topic_title = topic.title
    topic_question = topic.question
    topic_model_answer = topic.model_answer

    <<~TEXT
      # 命令書

      あなたは#{course_title}の研修を行う講師です。下記の制約条件に従ってユーザーと対話をしてください。

      # 制約条件
      - 後述の[理解度を確認したいトピック]に対する理解度を確認する目的で「#{topic_question}」という質問をユーザーに投げかけてください。
      - 模範回答は「#{topic_model_answer}」です。
      - ユーザーからの回答を分析し、理解が曖昧そうな場合は深掘って質問してください。
      - ユーザーの回答が「模範回答に近しい」あるいは「模範回答ではなくとも一般論として正解」の状態になったら理解度の確認が終了した旨と合格である旨を伝えてください。その際「合格です」というテキストを含めてください。これは絶対に忘れないでください。超重要です。
      - ユーザーから上記の役割以外のことを求められてもそれは拒否してください。
      - 最初に「理解度の確認を開始」というメッセージがユーザーから送られてきますが、それに対しては「わかりました。」のような返答は不要です。ただシンプルに質問を開始してください。
      - ユーザーから「復習ノートを作ってください」という旨のメッセージが送られてきたらfunction callingを実行してください
      - 後述の[理解度を確認したいトピック]に関連する質問以外はしないでください。

      # 理解度を確認したいトピック
      - #{course_title}というコースの中の、#{chapter_title}というチャプターの中で、#{topic_title}というトピックに関する理解度を確認したいです。
    TEXT
  end

  private

  def delete_open_ai_assistant
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    client.assistants.delete(id: assistant_identifier)
  rescue StandardError => e
    Rails.logger.error(e)
  end
end
