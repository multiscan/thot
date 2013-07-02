ThinkingSphinx::Index.define :book, :with => :active_record do

  indexes title, :sortable => true
  indexes author
  indexes editor
  indexes publisher.name, :as => :publisher, :sortable => true

  # attributes
  has publisher_id, created_at, updated_at, isbn

end
