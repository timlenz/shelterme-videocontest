class AddDetailsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :category_id, :integer
    add_column :videos, :approved, :boolean, default: false
    add_column :videos, :length, :float
    add_column :videos, :views_count, :integer, default: 0, null: false
    add_column :videos, :shares_count, :integer, default: 0, null: false
    add_column :videos, :votes_count, :integer, default: 0, null: false
  end
end
