class Group < ApplicationRecord
  has_many :memeberships
  has_many :users, :through => :memeberships
end
