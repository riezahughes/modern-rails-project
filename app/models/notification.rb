class Notification < ActiveRecord::Base

  has_and_belongs_to_many :users, uniq: true, join_table: :users_notifications
  has_many :notifiable_join_entities

  validates_presence_of :entity
  validates_uniqueness_of :entity

  def to_s
    entity.pluralize
  end

  def notifiables
    return [] if notifiable_join_entities.empty?
    notifiable_join_entities.map(&:notifiable)
  end

  def destroy_entities
    notifiable_join_entities.each { |notifiable_join_entity| notifiable_join_entity.destroy! }
  end

end
