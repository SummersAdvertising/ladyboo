class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :product_id
      t.string :name
      t.string :description_1
      t.string :description_2
      t.integer :amount
      t.boolean :assign_amount

      t.timestamps
    end
  end
end
