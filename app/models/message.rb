# == Schema Information
#
# Table name: messages
#
#  id                 :integer          not null, primary key
#  user_thread_id     :integer          not null
#  content            :string
#  sender_type        :integer
#  message_identifier :string
#  status             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_messages_on_user_thread_id  (user_thread_id)
#

class Message < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user_thread
  enum :sender_type, { user: 1, assistant: 2 }, prefix: true, validate: true
  enum :status, { before_processing: 0, processing: 1, completed: 2, failed: 3, expired: 4 }, prefix: true, validate: true

  def broadcast_chunk_received
    broadcast_replace_to(
      dom_id(user_thread),
      partial: "user_threads/messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(self)}"
    )
  end

  def broadcast_run_completed
    broadcast_replace_later_to(
      dom_id(user_thread),
      partial: "user_threads/messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(self)}"
    )

    broadcast_replace_later_to(
      dom_id(user_thread),
      partial: "user_threads/messages/form",
      locals: { form_disabled: (user_thread.status != "completed"), user_thread: user_thread, message: nil },
      target: "form"
    )

    # broadcast_replace_later_to(
    #   dom_id(user_thread),
    #   partial: "threads/user_thread_topic_progress_list",
    #   locals: {
    #     user_thread_topic_progresses: ChapterProgress.find_by!(user_id: user_thread.user.id, chapter_id: user_thread.topic.chapter.id).user_thread_topic_progresses.joins(:topic).order('topics.position asc').to_a,
    #     current_user_thread_id: user_thread.id
    #   },
    #   target: "user_thread_topic_progress_list"
    # )

    # broadcast_replace_later_to(
    #   dom_id(user_thread),
    #   partial: "threads/detail",
    #   locals: {
    #     user_thread: user_thread,
    #     user: user
    #   },
    #   target: "user_thread_detail"
    # )
  end
end
