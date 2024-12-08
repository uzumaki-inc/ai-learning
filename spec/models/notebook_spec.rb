# == Schema Information
#
# Table name: notebooks
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  user_id    :integer          not null
#  topic_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notebooks_on_topic_id  (topic_id)
#  index_notebooks_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe Notebook, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
