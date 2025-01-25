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

    return unless user_thread.status == "completed"

    broadcast_replace_to(
      dom_id(user_thread),
      partial: "user_threads/messages/form",
      locals: { form_disabled: false, user_thread: user_thread, message: nil },
      target: "form"
    )

    broadcast_replace_to(
      dom_id(user_thread),
      partial: "user_threads/topic_list",
      locals: {
        topics: user_thread.topic.chapter.topics.order(created_at: :asc).to_a, # TODO: positionでソートする
        current_topic_id: user_thread.topic_id,
        user: user_thread.user
      },
      target: "topic_list"
    )
  end
end
