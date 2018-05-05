class Event < ApplicationRecord
  STATUS = ["draft", "public", "private"]

  before_validation :generate_friendly_id, :on => :create

  # 这里不但要检查必填，还检查了必须唯一，而且格式只限小写英数字及横线。
  validates_presence_of :name, :friendly_id
  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, :with => /\A[a-z0-9\-]+\z/
  validates_inclusion_of :status, :in => STATUS

  def to_param
   self.friendly_id
  end

  def generate_friendly_id
   self.friendly_id ||= SecureRandom.uuid
  end

end
