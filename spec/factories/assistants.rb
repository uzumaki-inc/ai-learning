# == Schema Information
#
# Table name: assistants
#
#  id                   :integer          not null, primary key
#  assistant_identifier :string
#  topic_id             :integer          not null
#  type                 :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_assistants_on_topic_id  (topic_id)
#

FactoryBot.define do
  factory :assistant do
    assistant_identifier { "MyString" }
    topic { nil }
    type { 1 }
  end
end
