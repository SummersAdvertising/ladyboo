class CreateOrderlogs < ActiveRecord::Migration
  def change
    create_table :orderlogs do |t|
      t.integer :order_id
      t.string :content
      t.string :inner_state

      t.timestamps
    end
  end
end
