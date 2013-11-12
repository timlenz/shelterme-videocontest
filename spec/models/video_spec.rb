# == Schema Information
#
# Table name: videos
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  category_id     :integer
#  approved        :boolean         default(FALSE)
#  length          :float
#  plays_count     :integer         default(0), not null
#  shares_count    :integer         default(0), not null
#  votes_count     :integer         default(0), not null
#  title           :string(255)
#  panda_video_id  :string(255)
#  ave_vote        :float           default(0.0)
#  rating          :float
#  plays_quartile  :integer
#  shares_quartile :integer
#  votes_quartile  :integer
#

require 'spec_helper'

describe Video do
  pending "add some examples to (or delete) #{__FILE__}"
end
