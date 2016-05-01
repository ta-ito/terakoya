# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  urlsafe_name           :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  lock_version           :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  before_validation :set_urlsafe_name

  #config.email_regexp = /\A[^@]+@[^@]+\z/
  #config.password_length = 10..32

  validates :name,
    presence: true,
    length: {
      minimum: 6,
      maximum: 20,
      allow_blank: true,
    },
    format: {
      with: /\A[A-Za-z]+[0-9A-Za-z:@\.\+\*\/\\_-]*[0-9A-Za-z]+\z/,
      allow_blank: true,
    },
    uniqueness: {
      case_sensitive: false,
    }
  validates :urlsafe_name,
    presence: true,
    length: {
      minimum: 5,
      maximum: 20,
      allow_blank: true,
    },
    format: {
      with: /\A[a-z]+[0-9A-Za-z\._-]*[0-9a-z]+\z/,
      allow_blank: true,
    },
    uniqueness: true

  def self.urlsafe_name(name)
    name.gsub(/[:@\+\*\/\\]/, "").downcase
  end

  private

  def set_urlsafe_name
    self.urlsafe_name = User.urlsafe_name(self.name)
  end
end