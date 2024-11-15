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

require 'rails_helper'

RSpec.describe Topic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
