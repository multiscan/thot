# require "prawn/measurement_extensions"

docinfo = {
            :Title => @inventory_session.name,
            :Author => current_admin.name,
            :Subject => "Inventory Session",
            :Creator => "thot.epfl.ch",
            :Producer => "EPFL",
            :CreationDate => Time.now
          }


cells=[]
@items.each do |r|
  s=r.shelf_id.present? ? Shelf.find(r.shelf_id).seqno : " "
  i=r.inventoriable
  c=i.is_a?(Book) ? [i.call1, i.call2, i.call3].join(" ") : " "
  t="<b>#{truncate(i.author, :length=>50)}</b>\n<i>#{truncate(i.title, :length=>150)}</i>"
  b={draw: BarcodeCell.new(r.id)}
  cells << [r.id, s, c, t, b, nil]
end
prawn_document(
    page_size: "A4",
    page_layout: :portrait,
    margin: [13.mm, 10.mm],      # top/bottom, left/right as in css
    info: docinfo
  ) do |p|
  p.font_size 9
  p.table(
    cells,
    :column_widths => [20.mm, 10.mm, 30.mm, 80.mm, 30.mm, 10.mm],
    :cell_style => {border_width: 0.1, border_color: "CCCCCC", :inline_format => true}
  )
  string = "page <page> of <total>"
  # Green page numbers 1 to 7
  options = {
    :at => [p.bounds.right - 150, 0],
    :width => 150,
    :align => :right,
    :page_filter => (1..7),
    :start_count_at => 1,
    :color => "007700"
  }
  p.number_pages string, options

end
