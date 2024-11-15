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

require 'rails_helper'

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
