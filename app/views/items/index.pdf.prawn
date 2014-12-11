# require "prawn/measurement_extensions"

docinfo = {
            :Title => "Thot Book Labels",
            :Author => "Thot library system",
            :Subject => "Printable Labels for Library Books",
            :Creator => "thot.epfl.ch",
            :Producer => "EPFL",
            :CreationDate => Time.now
          }

ll = LabelLayout.find(params[:lf])
ll.pretty_print
if ll
  # pre prawn 1.3 (when no Prawn::View where available)
  # prawn_document(ll.page_params.merge({info: docinfo, print_scaling: :none})) do |p|
  #   p.auto_grid_start(ll.grid_params)
  #   @items.each do |item|
  #     p.auto_grid_next_bounding_box { p.item_label(item) }
  #   end
  # end
  p = PrawnLabelSheet.new(ll)
  p.auto_grid_start
  @items.each do |item|
    p.auto_grid_next_bounding_box { p.item_label(item) }
  end
  p.render
end
