# == Schema Information
#
# Table name: source_documents
#
#  id             :integer          not null, primary key
#  title          :string
#  uploaded_by_id :integer          not null
#  assistant_id   :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_source_documents_on_assistant_id    (assistant_id)
#  index_source_documents_on_uploaded_by_id  (uploaded_by_id)
#

class SourceDocument < ApplicationRecord
  belongs_to :uploaded_by
  belongs_to :assistant
end
