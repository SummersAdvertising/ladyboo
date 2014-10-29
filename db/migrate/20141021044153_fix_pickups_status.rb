class FixPickupsStatus < ActiveRecord::Migration
  def change
    change_column :pickups, :status,  :string, default: 'enable'
    change_column :banners, :status,  :string, default: 'enable'
  end
end
