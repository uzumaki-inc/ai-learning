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

class Notebook < ApplicationRecord
  belongs_to :user
  belongs_to :topic
end
