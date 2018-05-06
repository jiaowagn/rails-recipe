class Registration < ApplicationRecord
  belongs_to :user, :optional => true
  belongs_to :event
  belongs_to :ticket

  STATUS = ["pending", "confirmed"]
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :status, :ticket_id

  attr_accessor :current_step
  validates_presence_of :name, :email, :cellphone, :if => :should_validate_basic_data?
  validates_presence_of :name, :email, :cellphone, :bio, :if => :should_validate_all_data?

  before_validation :generate_uuid, :on => :create

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def to_param
    self.uuid
  end

  protected
    def should_validate_all_data?
      current_step == 3 || status == "confirmed"
    end

    def should_validate_basic_data?
      current_step == 2
    end
end
