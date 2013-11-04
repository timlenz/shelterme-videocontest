class AddAveVoteToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :ave_vote, :float, default: 0
  end
end
