class CreateOrderasks < ActiveRecord::Migration
  def change
    create_table :orderasks do |t|
      t.integer :order_id
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
