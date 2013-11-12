class AddQuartilesAndRatingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :rating, :float, default: 0
    add_column :videos, :plays_quartile, :integer, default: 0
    add_column :videos, :shares_quartile, :integer, default: 0
    add_column :videos, :votes_quartile, :integer, default: 0
  end
end
