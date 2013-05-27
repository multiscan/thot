class CreateOperatorships < ActiveRecord::Migration
  def change
    create_table :operatorships do |t|
      t.references :lab
      t.references :admin

      t.timestamps
    end
  end
end
