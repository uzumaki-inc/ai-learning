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
#  notebook_status       :integer
#
# Indexes
#
#  index_user_threads_on_topic_id  (topic_id)
#  index_user_threads_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe UserThread, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
