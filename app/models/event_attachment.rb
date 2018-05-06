class EventAttachment < ApplicationRecord
  belongs_to :event
  mount_uploader :attachment, EventAttachmentUploader
end
