class CreateRevenueDetails < ActiveRecord::Migration
  def change
    create_table :revenue_details do |t|
      t.integer :context_id
      t.string :context_displayname
      t.integer :figure
      t.string :type
      t.references :daily_report, index: true

      t.timestamps
    end
  end
end
