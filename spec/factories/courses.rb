# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :course do
    title { "MyString" }
    description { "MyText" }
    position { 1 }
  end
end
