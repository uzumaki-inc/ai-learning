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

class Course < ApplicationRecord
  has_many :chapters, dependent: :destroy
  has_many :topics, through: :chapters

  def progress_percentage(user)
    return 0 if user.nil?
    return 0 if user.user_topic_progresses.empty?
    return 0 if topics.empty?
    ((user.user_topic_progresses.status_completed.joins(topic: :chapter).where(chapter: { course_id: id }).count.to_f / topics.count.to_f) * 100).to_i
  end
end
