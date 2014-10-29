class AddTokenAndPayeridToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :token, :string
    add_column :orders, :payerid, :string
  end
end
