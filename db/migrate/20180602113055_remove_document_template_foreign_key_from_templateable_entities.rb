class RemoveDocumentTemplateForeignKeyFromTemplateableEntities < ActiveRecord::Migration

  # This is a clean up Migration, initially all DocumentTemplateable classes linked directly to DocumentTemplate
  # e.g. Meeting -> DocumentTemplate, Letter -> DocumentTemplate, FileForm -> DocumentTemplate, etc
  # Then a common TemplateDocument was introduced as a middle entity
  # e.g. Meeting -> TemplateDocument -> DocumentTemplate, Letter -> TemplateDocument -> DocumentTemplate, FileForm -> TemplateDocument-> DocumentTemplate, etc
  # The foreign_key constraint still lingers for the first approach and needs to be removed if there
  def up
    DocumentTemplateable.classes.map{ |klass| klass.table_name }
    .each do |table|
      if foreign_keys(table).any?{|k| k[:to_table] == "document_templates"}
        remove_foreign_key table, :document_templates
      end
    end
  end
end
