class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :ordernum
      t.string :buyer_name
      t.string :buyer_tel
      t.string :receiver_name
      t.string :receiver_tel
      t.string :receiver_address
      t.string :payment_type
      t.string :payment_status
      t.string :invoice_type
      t.string :invoice_companynum
      t.string :invoice_title
      t.string :aasm_state,          default: "hold"
      t.string :delivery_type
      t.string :package_tracking_no
      t.text :order_memo
      t.text :human_involved_memo
      t.string :accountinfo
      t.integer :items_total
      t.integer :shipping_fee
      t.string :ship_to
      t.string :shipped,             default: "no"
      t.string :paid,                default: "no"

      t.timestamps
    end
  end
end
