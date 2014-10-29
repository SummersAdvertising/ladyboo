class AddFillouttimeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fillout_date, :date
    add_column :orders, :invoice_address, :string
    add_column :products, :product_no, :string
  end
end
