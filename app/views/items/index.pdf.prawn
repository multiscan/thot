# require "prawn/measurement_extensions"

docinfo = {
            :Title => "Thot Book Labels",
            :Author => "Thot library system",
            :Subject => "Printable Labels for Library Books",
            :Creator => "thot.epfl.ch",
            :Producer => "EPFL",
            :CreationDate => Time.now
          }

case params[:lf]
when "3x8m"
  prawn_document(Prawn::Document::PAGE_PARAMS_38M.merge({info: docinfo})) do |p|
    p.auto_grid_start(:columns => 3, :rows => 8, :gutter => 0) #, :row_gutter => 16, :column_gutter => 8)
    @items.each do |item|
      p.auto_grid_next_bounding_box { p.item_label(item, 2.mm, 2.mm) }
    end
  end
when "3x8"
  prawn_document(Prawn::Document::PAGE_PARAMS_38.merge({info: docinfo})) do |p|
    p.auto_grid_start(:columns => 3, :rows => 8, :gutter => 12)
    @items.each do |item|
      p.auto_grid_next_bounding_box { p.item_label(item, 5.mm, 5.mm) }
    end
  end
else # dymo
  prawn_document(Prawn::Document::PAGE_PARAMS_DYMO.merge({info: docinfo})) do |p|
    fp = true
    @items.each do |item|
      p.start_new_page unless fp
      p.item_label(item)
      fp = false
    end
  end
end
