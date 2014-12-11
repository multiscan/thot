class CreateLabelLayouts < ActiveRecord::Migration
  def up
    create_table :label_layouts do |t|
      t.string  :name               # short name (for select dropdown)
      t.string  :description        # more verbose description

      t.integer :pw                 # page width
      t.integer :ph                 # page height

      t.integer :nr                 # number of label rows
      t.integer :nc                 # number of label columns

      t.integer :mt, default: 0     # margin top
      t.integer :mb, default: 0     # margin bottom
      t.integer :ml, default: 0     # margin left
      t.integer :mr, default: 0     # margin right

      t.integer :hs, default: 0     # horizontal spacing
      t.integer :vs, default: 0     # vertical spacing

      t.integer :vp, default: 2     # virtical padding
      t.integer :hp, default: 2     # horizontal padding

      # t.integer :bl                 # left label part %
      # t.integer :bc                 # center label part %
      # t.integer :br                 # right label part %

      t.timestamps
    end
    LabelLayout.create({
      name: 'Dymo Muriel',
      description: 'Label printer with continuous roll feeder. Label size: 75x30 mm',
      pw: 89,
      ph: 36,
      nc: 1,
      nr: 1,
      mt: 3,
      mb: 3,
      ml: 7,
      mr: 7,
    })
    LabelLayout.create({
      name: '3x8',
      description: 'Single A4 sheet with 24 labels covering the full surface without margins. Label size: ~70x37 mm',
      pw: 210,
      ph: 297,
      nc: 3,
      nr: 8,
    })
    LabelLayout.create({
      name: '3x8 Jaqueline',
      description: 'Single A4 sheet with 24 labels with dimensions 66x34',
      pw: 210,
      ph: 297,
      nc: 3,
      nr: 8,
      mt: 12,
      mb: 13,
      ml: 6,
      mr: 6,
    })
  end

  def down
    drop_table :label_layouts
  end
end
