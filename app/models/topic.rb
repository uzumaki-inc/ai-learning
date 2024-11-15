# == Schema Information
#
# Table name: topics
#
#  id           :integer          not null, primary key
#  title        :string
#  question     :text
#  model_answer :text
#  position     :integer
#  chapter_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_topics_on_chapter_id  (chapter_id)
#

class Topic < ApplicationRecord
  belongs_to :chapter
end
