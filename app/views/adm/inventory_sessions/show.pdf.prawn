# require "prawn/measurement_extensions"

@records = [["Inv", "Lab", "Call1", "Call2", "Call3", "Title"]]
@records += @inventory_session.books_by_call_for_listing.sort{|a,b| a.sortable_call <=> b.sortable_call}.map{|r| [r.id, r.lab_nick, r.call1, r.call2, r.call3, truncate(r.title, :length => 48)]}

docinfo = {
            :Title => @inventory_session.name,
            :Author => current_admin.name,
            :Subject => "Inventory Session",
            :Creator => "thot.epfl.ch",
            :Producer => "EPFL",
            :CreationDate => Time.now
          }

prawn_document(
    page_size: "A4",
    page_layout: :portrait,
    margin: [13.mm, 10.mm],      # top/bottom, left/right as in css
    info: docinfo
  ) do |p|
  p.font_size 10
  p.table(
    @records,
    :column_widths => [20.mm, 25.mm, 20.mm, 20.mm, 20.mm, 85.mm],
    :cell_style => {border_width: 0.1, border_color: "CCCCCC"}
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
