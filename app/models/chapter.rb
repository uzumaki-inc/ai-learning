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

class Chapter < ApplicationRecord
  belongs_to :course
  has_many :topics, dependent: :destroy
end
