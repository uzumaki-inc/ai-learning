class GetAiResponseJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 5.seconds, attempts: 5 do |job, error|
    # ここで最終的に失敗し続けたときに行う処理がかける
    # ExceptionNotifier.notify_exception(error)
  end

  def perform(user_thread_id:)
    user_thread = UserThread.find(user_thread_id)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:open_ai, :access_token))
    while true do
      run_response = client.runs.retrieve(id: user_thread.latest_run_identifier, thread_id: user_thread.thread_identifier)
      Rails.logger.info "run_response_status: #{run_response['status']}"
      case run_response["status"]
      when "completed"
        user_thread.update!(status: :completed)
        messages = client.messages.list(thread_id: user_thread.thread_identifier)
        content = messages["data"].first.dig("content", 0, "text", "value")
        id = messages["data"].first.dig("id")
        message = user_thread.messages.order(created_at: :asc).last # TODO
        message.update!(content: content, message_identifier: id, status: :completed)

        if content.include?("合格です")
          user_thread_progress = user_thread.user_thread_progress
          user_thread_progress.update!(status: :completed)
          user_topic_progress = UserTopicProgress.find_by!(user_id: user_thread.user_id, topic_id: user_thread.topic_id)
          user_topic_progress.update!(status: :completed)
        end

        message.broadcast_run_completed
        break
      when "requires_action"
        p "--------------requires_action-----------------"
        p "--------------requires_action-----------------"
        p "--------------requires_action-----------------"
        tools_to_call = run_response.dig('required_action', 'submit_tool_outputs', 'tool_calls')
        my_tool_outputs = tools_to_call.map { |tool|
          # Call the functions based on the tool's name
          function_name = tool.dig('function', 'name')
          arguments = JSON.parse(
            tool.dig("function", "arguments"),
            { symbolize_names: true },
            )

          p arguments
          tool_output = case function_name
                        when "generate_learning_note"
                          generate_learning_note(user_thread, **arguments)
                        end

          { tool_call_id: tool['id'], output: tool_output }
        }

        client.runs.submit_tool_outputs(
          thread_id: user_thread.thread_identifier,
          run_id: user_thread.latest_run_identifier,
          parameters: { tool_outputs: my_tool_outputs }
        )

      when "failed"
        # TODO
        user_thread.update!(status: :failed)
        message.update!(status: :failed)
        message.broadcast_run_completed
        break
      when "expired"
        # TODO
        user_thread.update!(status: :expired)
        message.update!(status: :expired)
        message.broadcast_run_completed
        break
      else
        # TODO
      end
      sleep 2
    end
  end

  def generate_learning_note(user_thread, arguments)
    p "----------------generate_learning_note----------------"
    p "----------------generate_learning_note----------------"
    p "----------------generate_learning_note----------------"
    learning_notes = arguments[:learning_notes]
    topic = user_thread.topic
    learning_notes.each do |learning_note|
      title = learning_note[:topic]
      model_answer = learning_note[:model_answer]
      Notebook.create(title: title, content: model_answer, user_id: user_thread.user_id, topic_id: topic.id)
    end
    p arguments
    "学習ノートを生成しました。"
  end
end
