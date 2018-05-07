class Registration < ApplicationRecord
  belongs_to :user, :optional => true
  belongs_to :event
  belongs_to :ticket

  has_paper_trail

  STATUS = ["pending", "confirmed"]
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :status, :ticket_id

  attr_accessor :current_step
  validates_presence_of :name, :email, :cellphone, :if => :should_validate_basic_data?
  validates_presence_of :name, :email, :cellphone, :bio, :if => :should_validate_all_data?
  validate :check_event_status, :on => :create

  before_validation :generate_uuid, :on => :create

  scope :by_status, ->(s){where(:status => s)}
  scope :by_ticket, ->(t){where(:ticket_id => t)}

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def to_param
    self.uuid
  end

  protected
    def check_event_status
      if self.event.status == "draft"
        errors.add(:base, "活动尚未开放报名")
      end
    end

    def should_validate_all_data?
      current_step == 3 || status == "confirmed"
    end

    def should_validate_basic_data?
      current_step == 2
    end
end
