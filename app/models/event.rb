class Event < ApplicationRecord
  before_validation :generate_friendly_id, :on => :create

 validates_presence_of :name

 def to_param
   self.friendly_id
 end

 def generate_friendly_id
   self.friendly_id ||= SecureRandom.uuid
 end

end
