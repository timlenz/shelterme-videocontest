class RenameViewsToPlays < ActiveRecord::Migration
  def self.up
    rename_table :views, :plays
  end

  def self.down
    rename_table :plays, :views
  end
end
