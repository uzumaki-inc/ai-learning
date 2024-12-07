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

class User < ApplicationRecord
  has_many :user_threads, dependent: :destroy
  has_many :user_topic_progresses, dependent: :destroy
  has_many :notebooks, dependent: :destroy
end
