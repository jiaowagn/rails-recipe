class Registration < ApplicationRecord
  belongs_to :user, :optional => true
  belongs_to :event
  belongs_to :ticket

  STATUS = ["pending", "confirmed"]
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :status, :ticket_id

  before_validation :generate_uuid, :on => :create

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def to_param
    self.uuid
  end
end
