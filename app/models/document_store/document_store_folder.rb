class DocumentStoreFolder < DocumentStoreItem

  def icon
    'jstree-folder'
  end

  def children
    @object.children.each_child.collect do |child|
      if child.object_type_id == 'cmis:folder'
        DocumentStoreFolder.new child
      elsif child.object_type_id == 'cmis:document'
        DocumentStoreDocument.new child
      else
        DocumentStoreFolder.new child
      end
    end
  end

  def child_by_name(name)
    @object.children.each_child.collect do |child|
      if child.name == name
        if child.object_type_id == 'cmis:folder'
          child = DocumentStoreFolder.new child
        elsif child.object_type_id == 'cmis:document'
          child = DocumentStoreDocument.new child
        else
          child = DocumentStoreFolder.new child
        end
        return child
      end
    end
    nil
  end

end
