# == Schema Information
#
# Table name: chapter_progresses
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  chapter_id :integer          not null
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chapter_progresses_on_chapter_id  (chapter_id)
#  index_chapter_progresses_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe ChapterProgress, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
