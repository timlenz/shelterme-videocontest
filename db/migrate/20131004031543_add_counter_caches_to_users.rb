class AddCounterCachesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plays_count, :integer, default: 0, null: false
    add_column :users, :shares_count, :integer, default: 0, null: false
    add_column :users, :votes_count, :integer, default: 0, null: false
    add_column :users, :videos_count, :integer, default: 0, null: false

    User.reset_column_information
		User.find_each do |user|
      User.reset_counters user.id, :plays
      User.reset_counters user.id, :shares
      User.reset_counters user.id, :votes
      User.reset_counters user.id, :videos
    end
  end
end
