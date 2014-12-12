ll = LabelLayout.find(params[:lf])
if ll
  p = PrawnLabelSheet.new(ll)
  p.auto_grid_start
  @items.each do |item|
    p.auto_grid_next_bounding_box { p.item_label(item) }
  end
  p.render
end
