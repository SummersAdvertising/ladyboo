class CreateOrderitems < ActiveRecord::Migration
  def change
    create_table :orderitems do |t|
      t.integer :order_id
      t.integer :product_stock_id
      t.string :item_name
      t.string :item_stockname
      t.integer :item_price
      t.integer :amount

      t.timestamps
    end
  end
end
