ll = LabelLayout.find(params[:lf])
if ll
  p = PrawnLabelSheet.new(ll)
  p.auto_grid_start
  @shelves.each do |shelf|
    p.auto_grid_next_bounding_box { p.shelf_label(shelf) }
  end
  p.render
end
