require "prawn/measurement_extensions"

docinfo = {
            :Title => "Thot Book Labels",
            :Author => "#{current_admin.name}",
            :Subject => "Printable Labels for Library Shelves",
            :Creator => "thot.epfl.ch",
            :Producer => "EPFL",
            :CreationDate => Time.now
          }

case params[:lf]
when "3x8m"
  prawn_document(Prawn::Document::PAGE_PARAMS_38M.merge({info: docinfo})) do |p|
    p.auto_grid_start(:columns => 3, :rows => 8)
    @shelves.each do |shelf|
      p.auto_grid_next_bounding_box { p.shelf_label(shelf) }
    end
  end
when "3x8"
  prawn_document(Prawn::Document::PAGE_PARAMS_38.merge({info: docinfo})) do |p|
    p.auto_grid_start(:columns => 3, :rows => 8)
    @shelves.each do |shelf|
      p.auto_grid_next_bounding_box { p.shelf_label(shelf) }
    end
  end
else # dymo
  prawn_document(Prawn::Document::PAGE_PARAMS_DYMO.merge({info: docinfo})) do |p|
    fp = true
    @shelves.each do |shelf|
      p.start_new_page unless fp
      p.shelf_label(shelf)
      fp = false
    end
  end
end
