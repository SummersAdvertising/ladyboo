class CreatePickups < ActiveRecord::Migration
  def change
    create_table :pickups do |t|
      t.string :title
      t.string :description
      t.integer :product_id
      t.integer :ranking, :null => false, :default => 999
      t.integer :status

      t.timestamps
    end
  end
end
