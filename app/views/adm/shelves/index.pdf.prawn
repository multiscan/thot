# require "prawn/measurement_extensions"

docinfo = {
            :Title => "Thot Book Labels",
            :Author => "#{current_admin.name}",
            :Subject => "Printable Labels for Library Shelves",
            :Creator => "thot.epfl.ch",
            :Producer => "EPFL",
            :CreationDate => Time.now
          }



ll = LabelLayout.find(params[:lf])
ll.pretty_print
if ll
  p = PrawnLabelSheet.new(ll)
  p.auto_grid_start
  @shelves.each do |shelf|
    p.auto_grid_next_bounding_box { p.shelf_label(shelf) }
  end
  p.render
end
