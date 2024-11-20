class StartTopicJob < ApplicationJob
  queue_as :default

  # start_by!メソッドの中身も全部ジョブに書いちゃっても良さげ？そうするとuser_threadのidが得られないという問題があるか。
  def perform(user_thread_id:, assistant_message_id:)
    user_thread = UserThread.find(user_thread_id)
    assistant_message = Message.find(assistant_message_id)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    thread_response = client.threads.create
    thread_id = thread_response["id"]
    client.messages.create(
      thread_id:,
      parameters: {
        role: "user",
        content: "理解度の確認を開始。ハルシネーションは起こさないでください。"
      }
    )
    assistant = Assistant.find_by!(topic_id: user_thread.topic_id)
    run_response = client.runs.create(thread_id:,
                                      parameters: {
                                        assistant_id: assistant.assistant_identifier,
                                        stream: proc do |chunk, _bytesize|
                                          case chunk["object"]
                                          when "thread.message.delta"
                                            new_content = assistant_message.content + chunk.dig(
                                              "delta", "content", 0, "text", "value"
                                            )
                                            assistant_message.assign_attributes(content: new_content)
                                            assistant_message.broadcast_chunk_received
                                          when "thread.run"
                                            run_id = chunk["id"]
                                            if user_thread.latest_run_identifier != run_id
                                              assistant_message.update!(status: :processing)
                                              user_thread.update!(thread_identifier: thread_id, latest_run_identifier: run_id, status: :queued)
                                              GetAiResponseJob.perform_later(user_thread_id: user_thread.id)
                                            end
                                          end
                                        end
                                      })
  end
end
