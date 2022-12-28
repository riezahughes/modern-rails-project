class Permission < ActiveRecord::Base

  before_save :format_fields

  has_and_belongs_to_many :groups

  validates_uniqueness_of :subject_class, scope: :action
  validates_presence_of :subject_class
  validates_presence_of :action

  def format_fields
    self.action = action.downcase
  end

  def display_name
    "#{self.action.capitalize} #{self.subject_class}"
  end

end
