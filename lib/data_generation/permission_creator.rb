class DataGeneration::PermissionCreator

  def setup_actions_controllers_db
    write_permission("all", "manage")
    write_permission("all", "read")

    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |controller|
      if controller =~ /_controller/
        foo_bar = controller.camelize.gsub(".rb", "").constantize.new
      end
    end
    # You can change ApplicationController for a super-class used by your restricted controllers
    AuthoritativeController.subclasses.each do |controller|
      controller_class = controller.to_s.sub("Controller", "").singularize
      write_permission(controller_class, "manage")
      controller.action_methods.each do |action|
        if action.to_s.index("_callback").nil?
          action = self.eval_cancan_action(action)
          write_permission(controller_class, action)
        end
      end
    end
  end

  def eval_cancan_action(action)
    case action.to_s
    when "index", "show", "search", "fetch_file"
        cancan_action = "read"
      when "create", "new"
        cancan_action = "create"
      when "edit", "update"
        cancan_action = "update"
      when "delete", "destroy"
        cancan_action = "delete"
      else
        cancan_action = action.to_s
    end
    cancan_action
  end

  def write_permission(class_name, action)
    permission = Permission.where(subject_class: class_name, action: action).first
    unless permission
      permission = Permission.new
      permission.subject_class = class_name
      permission.action = action
      permission.save
    end
  end

end
