# == Schema Information
#
# Table name: chapters
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  position    :integer
#  course_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_chapters_on_course_id  (course_id)
#

FactoryBot.define do
  factory :chapter do
    title { "MyString" }
    description { "MyText" }
    position { 1 }
    course { nil }
  end
end
