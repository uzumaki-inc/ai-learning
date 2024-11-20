# == Schema Information
#
# Table name: user_topic_progresses
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  topic_id   :integer          not null
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_topic_progresses_on_topic_id  (topic_id)
#  index_user_topic_progresses_on_user_id   (user_id)
#

class UserTopicProgress < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  enum :status, { in_progress: 1, completed: 2 }, prefix: true, validate: true, default: :in_progress
end
