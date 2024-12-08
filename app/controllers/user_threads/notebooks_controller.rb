class UserThreads::NotebooksController < ApplicationController
  def create
    user_thread = UserThread.find(params[:user_thread_id])
    user_thread.update(notebook_status: :in_progress)
    CreateNotebooksJob.perform_later(user_thread_id: user_thread.id)
    redirect_to user_thread
  end
end
