class CreateNotebooksJob < ApplicationJob
  queue_as :default

  def perform(user_thread_id:)
    user_thread = UserThread.find(user_thread_id)
    user_thread.create_notebooks
    user_thread.update(notebook_status: :completed)
    user_thread.broadcast_notebook_created
  end
end
