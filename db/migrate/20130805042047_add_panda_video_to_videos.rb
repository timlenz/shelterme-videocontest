class AddPandaVideoToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :panda_video_id, :string
  end
end
