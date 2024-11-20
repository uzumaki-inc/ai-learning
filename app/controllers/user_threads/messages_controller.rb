class UserThreads::MessagesController < ApplicationController
  def create
    @user_thread = UserThread.find_by!(user_id: current_user.id, id: params[:user_thread_id])

    @user_message = Message.new(content: params[:message][:content], sender_type: :user, user_thread_id: @user_thread.id, status: :completed)

    if @user_message.save
      @user_thread.update(status: :queued)
      @assistant_message = Message.create!(content: "", sender_type: :assistant, user_thread_id: @user_thread.id, status: :before_processing)
      PostMessageToAiJob.perform_later(user_message_id: @user_message.id, assistant_message_id: @assistant_message.id)
    else
      @messages = @user_thread.messages.order(created_at: :asc).offset(1)
      @message = @user_message
      render "threads/show", status: :unprocessable_entity
    end
  end
end
