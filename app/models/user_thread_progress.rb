# == Schema Information
#
# Table name: user_thread_progresses
#
#  id             :integer          not null, primary key
#  user_thread_id :integer          not null
#  status         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_user_thread_progresses_on_user_thread_id  (user_thread_id)
#

class UserThreadProgress < ApplicationRecord
  belongs_to :user_thread
  enum :status, { in_progress: 1, completed: 2 }, prefix: true, validate: true
end
