class PostMessageToAiJob < ApplicationJob
  queue_as :default

  def perform(user_message_id:, assistant_message_id:)
    user_message = Message.find(user_message_id)
    assistant_message = Message.find(assistant_message_id)
    user_thread = user_message.user_thread
    assistant = Assistant.find_by!(topic_id: user_thread.topic.id)

    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))

    thread_id = if user_thread.thread_identifier.present?
                  user_thread.thread_identifier
    else
                  create_thread(user_thread)
    end

    user_message_by_open_ai = client.messages.create(
      thread_id:,
      parameters: {
        role: "user",
        content: user_message.content
      }
    )

    user_message.update!(message_identifier: user_message_by_open_ai["id"])
    user_thread.update!(status: :queued)

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
                             user_thread.update!(latest_run_identifier: run_id)

                             status = chunk["status"]
                              if status == "in_progress"
                                assistant_message.update!(status: :processing)
                              end
                           when "thread.message"
                             status = chunk["status"]
                             if status == "completed"
                               user_thread.update!(status: :completed)
                               id = chunk["id"]
                               content = chunk.dig(
                                 "content", 0, "text", "value"
                               )
                               assistant_message.update!(content: content, message_identifier: id, status: :completed)
                               if content.include?("合格です")
                                 user_thread_progress = user_thread.user_thread_progress
                                 user_thread_progress.update!(status: :completed)
                                 user_topic_progress = UserTopicProgress.find_by!(user_id: user_thread.user_id, topic_id: user_thread.topic_id)
                                 user_topic_progress.update!(status: :completed)
                               end
                               assistant_message.reload.broadcast_chunk_received
                             end
                           end
                         end
                       })
  end

  def create_thread(user_thread)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    thread_response = client.threads.create
    thread_id = thread_response["id"]
    user_thread.update!(thread_identifier: thread_id)
    thread_id
  end
end
