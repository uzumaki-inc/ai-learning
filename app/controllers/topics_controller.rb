class TopicsController < ApplicationController
  def show
  end
  def start
    @topic = Topic.find(params[:id])
    if current_user
      @topic.start_by!(current_user)
      target_user_thread = UserThread.find_by!(user_id: current_user.id, topic_id: @topic.id)
      redirect_to user_thread_path(target_user_thread)
    end
  end
end
