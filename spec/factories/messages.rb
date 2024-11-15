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

FactoryBot.define do
  factory :message do
    user_thread { nil }
    content { "MyString" }
    sender_type { 1 }
    message_identifier { "MyString" }
    status { 1 }
  end
end
