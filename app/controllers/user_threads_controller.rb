class UserThreadsController < ApplicationController
  def show
    @user_thread = current_user.user_threads.find(params[:id])

    @messages = @user_thread.messages.order(created_at: :asc).offset(1)
    @topics = @user_thread.topic.chapter.topics.order(position: :asc)
  end
end
