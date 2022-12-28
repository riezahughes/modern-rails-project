class DocumentStoreItem
  include ActiveModel::Model

  attr_accessor :id, :name, :description, :object

  def initialize(cmis_object)
    @object = cmis_object
  end

  def id
    @object.cmis_object_id
  end

  def name
    @object.name
  end

  def description
    @object.description
  end

  def node_ref
    @object.properties['alfcmis:nodeRef']
  end

  def delete!
    @object.delete
  end

  def delete
    begin
      @object.delete
      true
    rescue Exception => e
      Rails.logger.warn "Unable to delete: #{e.message}"
      false
    end
  end

  def icon
    'jstree-file'
  end

  def children
    []
  end

  def to_json
    {
        text: name,
        icon: icon,
        children: children.collect { |child| child.to_json }
    }
  end

end
