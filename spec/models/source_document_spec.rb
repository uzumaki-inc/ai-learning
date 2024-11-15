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

require 'rails_helper'

RSpec.describe SourceDocument, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
