class ChangeVideos < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.rename :views_count, :plays_count
    end
  end
end
