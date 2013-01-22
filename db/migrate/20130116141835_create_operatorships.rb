class CreateOperatorships < ActiveRecord::Migration
  def change
    create_table :operatorships do |t|
      t.references :lab
      t.references :user

      t.timestamps
    end
  end
end
