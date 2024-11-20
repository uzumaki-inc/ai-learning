# == Schema Information
#
# Table name: user_threads
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  topic_id              :integer          not null
#  thread_identifier     :string
#  latest_run_identifier :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_user_threads_on_topic_id  (topic_id)
#  index_user_threads_on_user_id   (user_id)
#

class UserThread < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_one :user_thread_progress, dependent: :destroy
  has_many :messages, dependent: :destroy
  enum :status, { unprocessed: 0, queued: 1, in_progress: 2, cancelling: 3, completed: 4, requires_action: 5, cancelled: 6, failed: 7, expired: 8 }, prefix: true, validate: true
end
