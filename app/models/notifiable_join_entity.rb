class NotifiableJoinEntity < ActiveRecord::Base
  belongs_to :notification
  belongs_to :notifiable, polymorphic: true

  validates_presence_of :notifiable
  validates :notifiable_id, uniqueness: { scope: :notifiable_type }
end
