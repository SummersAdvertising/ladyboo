class CreateTrackingLists < ActiveRecord::Migration
  def change
    create_table :tracking_lists do |t|
      t.references :user, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
