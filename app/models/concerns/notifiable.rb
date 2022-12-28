module Notifiable
  extend ActiveSupport::Concern

  included do
    has_one :notifiable_join_entity, as: :notifiable, dependent: :destroy
    has_one :notification, through: :notifiable_join_entity

    before_create :set_notification
  end

  def self.classes
    Rails.application.eager_load!
    ActiveRecord::Base.descendants
        .select { |c| c.included_modules.include?(Notifiable) }
        .collect { |c| c.name }
  end

  def register_for_notification
    set_notification
    save!
  end

  def unregister_for_notification
    if registered_for_notification?
      notifiable_join_entity = self.notifiable_join_entity
      self.notifiable_join_entity = nil
      save! && notifiable_join_entity.destroy
    else
      false
    end
  end

  def registered_for_notification?
    !self.notifiable_join_entity.nil?
  end

  private
  def set_notification
    self.notification = Notification.find_by_entity(self.class.name.demodulize)
  end

end