# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  password_digest      :string
#  demo_user_identifier :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
