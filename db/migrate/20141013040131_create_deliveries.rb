class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :name
      t.string :tracking_url
      t.integer :normal_fee,         default: 600
      t.integer :discount_fee,       default: 0
      t.integer :discount_criteria,  default: 6000
      t.string :iscod
      t.string :shipping_condition

      t.timestamps
    end
  end
end
