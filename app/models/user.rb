class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memeberships
  has_many :groups, :through => :memeberships
  has_one :profile
  has_many :registrations
  accepts_nested_attributes_for :profile

  ROLES = ['admin', 'editor']

  def display_name
    self.email.split("@").first
  end

  def is_admin?
    self.role == 'admin'
  end

  def is_editor?
    ['admin', 'editor'].include?(self.role)
  end

end
