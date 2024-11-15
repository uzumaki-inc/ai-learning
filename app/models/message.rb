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
  belongs_to :user_thread
end
