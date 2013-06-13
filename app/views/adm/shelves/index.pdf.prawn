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
  prawn_document(
                  page_size: "A4",
                  page_layout: :portrait,
                  margin: [13.mm, 8.mm],      # top/bottom, left/right as in css
                  info: docinfo
                ) do |p|
    p.auto_grid_start(:columns => 3, :rows => 8)
    @shelves.each do |shelf|
      p.auto_grid_next_bounding_box { p.shelf_label(shelf) }
    end
  end
when "3x8"
  prawn_document(
                  page_size: "A4",
                  page_layout: :portrait,
                  margin: 0,
                  info: docinfo
                ) do |p|
    p.auto_grid_start(:columns => 3, :rows => 8)
    @shelves.each do |shelf|
      p.auto_grid_next_bounding_box { p.shelf_label(shelf) }
    end
  end
else # dymo
  prawn_document(
                  page_size: [89.mm, 36.mm],
                  page_layout: :portrait,
                  margin: 0,
                  info: docinfo
                ) do |p|
    fp = true
    @shelves.each do |shelf|
      p.start_new_page unless fp
      p.shelf_label(shelf)
      fp = false
    end
  end
end
