class Ticket < ApplicationRecord
  belongs_to :event
  has_many :registrations 
  validates_presence_of :name, :price
end
