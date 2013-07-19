class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :video_id
      t.integer :user_id

      t.timestamps
    end
  end
end
