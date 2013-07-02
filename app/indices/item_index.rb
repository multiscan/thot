ThinkingSphinx::Index.define :item, :with => :active_record do
    polymorphs inventoriable, to: %w{Book}
    indexes inventoriable.title,  :as => :book_title
    indexes inventoriable.author, :as => :book_author
    indexes inventoriable.editor, :as => :book_editor

    where "inventoriable_type = 'Book'"

    # attributes
    has lab_id, location_id, status #, call1, call2, call3, call4
    has "books.publisher_id", :as=>:publisher_id, :type=>:integer
    has "books.pubyear", :as=>:pubyear, :type=>:integer
  end
