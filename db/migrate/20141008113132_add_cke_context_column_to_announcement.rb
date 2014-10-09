class AddCkeContextColumnToAnnouncement < ActiveRecord::Migration
  def change
    add_column :announcements, :ck_context, :text
  end
end
