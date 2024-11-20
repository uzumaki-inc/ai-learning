class PostMessageToAiJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 5.seconds, attempts: 5 do |_job, error|
    # ここで最終的に失敗し続けたときに行う処理がかける
    # ExceptionNotifier.notify_exception(error)
  end

  def perform(user_message_id:, assistant_message_id:)
    message = Message.find(user_message_id)
    assistant_message = Message.find(assistant_message_id)
    assistant_message.update!(status: :processing)
    user_thread = message.user_thread
    assistant = Assistant.find_by!(topic_id: user_thread.topic.id)

    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    thread_id = user_thread.thread_identifier

    ai_message = client.messages.create(
      thread_id:,
      parameters: {
        role: "user",
        content: message.content
      }
    )

    message.update!(message_identifier: ai_message["id"])

    accumulated_content = ""
    client.runs.create(thread_id:,
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
                               user_thread.update!(latest_run_identifier: run_id, status: :queued)
                               GetAiResponseJob.perform_later(user_thread_id: user_thread.id)
                             end
                           end
                         end
                       })
  end
end
