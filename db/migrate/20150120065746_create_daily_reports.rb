class CreateDailyReports < ActiveRecord::Migration
  def change
    create_table :daily_reports do |t|
      t.string :name
      t.integer :total_order_count
      t.integer :onhold_order_count
      t.integer :valid_order_count
      t.integer :completed_order_count
      t.integer :cancel_order_count
      t.integer :abnormal_end_order_count
      t.integer :new_member_count
      t.integer :total_shipping_revenue
      t.integer :total_product_revenue
      t.datetime :run_at
      t.datetime :target_date
      
      t.timestamps
    end
  end
end
