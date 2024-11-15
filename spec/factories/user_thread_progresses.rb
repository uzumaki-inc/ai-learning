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

FactoryBot.define do
  factory :user_thread_progress do
    user_thread { nil }
    status { 1 }
  end
end
