class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memeberships
  has_many :groups, :through => :memeberships
  has_one :profile 

  def display_name
    self.email.split("@").first
  end

end
