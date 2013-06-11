require "prawn/measurement_extensions"

def ciccio(p)
  p.text("ciccio")
end

prawn_document(
                page_size: "A4",
                page_layout: :portrait,
                left_margin: 100,
                right_margin: 100,
                top_margin: 100,
                bottom_margin: 100,
                info: {
                  :Title => "Thot Book Labels",
                  :Author => "#{current_admin.name}",
                  :Subject => "Printable Labels for Library Books",
                  :Creator => "thot.epfl.ch",
                  :Producer => "EPFL",
                  :CreationDate => Time.now
                }
              ) do |p|

  # p.set2of5dict
  # p.stroke_rectangle [0,0], 400, 100
  # p.inv_barcode("0123456789", 400, 100)
  p.canvas do
    p.auto_grid_start(:columns => 3, :rows => 8)
    p.auto_grid_next_bounding_box do
      # p.stroke_color 100, 0, 0, 0
      p.text "-1-"
      p.text "[#{p.bounds.left},#{p.bounds.top}] -> [#{p.bounds.right}, #{p.bounds.bottom}]"
      p.stroke_bounds
      # p.inv_barcode("0123456789", 100, 20)
    end
    p.auto_grid_next_bounding_box do
      # p.stroke_color 0, 100, 0, 0
      p.text "-2-"
      p.inv_barcode("0123456789", 100, 20)
    end
    p.auto_grid_next_bounding_box do
      # p.stroke_color 0, 0, 100, 0
      p.text "-3-"
      p.stroke_bounds
      # p.inv_barcode("0123456789", 100, 20)
    end
    p.auto_grid_next_bounding_box do
      # p.stroke_color 0, 0, 0, 100
      p.text "-4-"
      # p.inv_barcode("0123456789", 100, 20)
    end
    p.auto_grid_next_bounding_box do
      p.text "-5-"
      # p.inv_barcode("0123456789", 100, 20)
    end
        # p.grid(4,0).show
  # p.grid(6,1).show
  # p.grid([6,2], [7,3]).show

  #   p.fill_circle [p.bounds.left, p.bounds.top], 30
  #   p.fill_circle [p.bounds.right, p.bounds.top], 30
  #   p.fill_circle [p.bounds.right, p.bounds.bottom], 30
  #   p.fill_circle [p.bounds.left, p.bounds.bottom], 30
    # p.define_grid(:columns => 3, :rows => 8, :gutter => 10)
  #   # p.grid.show_all
  end

  # p.text "top: #{p.bounds.top}"
  # p.text "bottom: #{p.bounds.bottom}"
  # p.text "left: #{p.bounds.left}"
  # p.text "right: #{p.bounds.right}"

  # p.move_down 10
  # p.text "absolute top: #{p.bounds.absolute_top}"
  # p.text "absolute bottom: #{p.bounds.absolute_bottom}"
  # p.text "absolute left: #{p.bounds.absolute_left}"
  # p.text "absolute right: #{p.bounds.absolute_right}"

  # p.move_down 10
  # p.text "top: #{p.bounds.top}"
  # p.text "bottom: #{p.bounds.bottom}"
  # p.text "left: #{p.bounds.left}"
  # p.text "right: #{p.bounds.right}"
  # p.text "absolute top: #{p.bounds.absolute_top}"
  # p.text "absolute bottom: #{p.bounds.absolute_bottom}"
  # p.text "absolute left: #{p.bounds.absolute_left}"
  # p.text "absolute right: #{p.bounds.absolute_right}"


  # p.define_grid(:columns => 5, :rows => 8, :gutter => 10)
  # # p.grid.show_all

  # p.grid(4,0).show
  # p.grid(6,1).show
  # p.grid([6,2], [7,3]).show

  # p.grid(2,2).bounding_box do
  #   p.stroke_bounds
  #   p.text "this is in grid 2,2 bla bla bla bla."
  #   p.text "Another test line."
  # end

  # p.ciccio

  # # p.stroke_horizontal_rule
  # p.stroke_bounds
  # p.stroke_circle [0,0], 2
  # p.stroke_circle [10,0], 2
  # p.stroke_circle [0,10], 2
  # p.stroke_circle [10.mm, 10.mm], 5.mm
  # p.text "ciao"
  # # bounding box parte da in alto a sx e scende giu di width
  # p.bounding_box([100,200], :width => 100, :height => 100) do
  #   p.stroke_bounds
  #   p.stroke do
  #     p.circle [0,0], 2
  #     p.circle [10,0], 2
  #     p.circle [0,10], 2
  #   end
  # end

  # p.fill { p.circle [150,150], 15 }
  # # p.stroke { p.horizontal_line 0, 500, :at=>0 }
  # # p.stroke { p.vertical_line 0, 500, :at=>0 }
  # p.fill_rounded_rectangle [400,400], 100, 30, 5

  # pentagon_points = [500, 100], [430, 5], [319, 41], [319, 159], [430, 195]
  # pentagram_points = [0, 2, 4, 1, 3].map{ |i| pentagon_points[i] }
  # p.line_width = 10
  # p.stroke_rounded_polygon(20, *pentagon_points)
  # p.line_width = 1

  # 12.times do |i|
  #   p.rotate(i*30, :origin => [400,400]) do
  #     p.stroke_rectangle [350,225], 100, 50
  #     p.draw_text "Rotated #{i *30}", :size => 10, :at => [360, 205]
  #   end
  # end

  # p.stroke_color 50, 100, 0, 0
  # 1.upto(3) do |i|
  #   x = i * 50
  #   y = i * 100
  #   p.translate(x, y) do
  #     p.fill_circle [0,0], 2
  #     p.draw_text "New origin after translation to [#{x}, #{y}]", :at => [5, -2], :size => 8
  #     p.stroke_rectangle [100, 75], 100, 50
  #     p.text_box "Top left corner at [100,75]", :at => [110,65], :width => 80, :size=>8
  #   end
  # end

  # p.font("Helvetica", :size => 12)
  # p.text "Ciiiiaaaaooooo"
end
