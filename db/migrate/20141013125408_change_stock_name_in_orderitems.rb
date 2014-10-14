class ChangeStockNameInOrderitems < ActiveRecord::Migration
  def change
    add_column :orderitems, :stock_id, :integer
    remove_column :orderitems, :product_stock_id
  end
end
