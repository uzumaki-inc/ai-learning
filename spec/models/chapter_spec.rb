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

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
