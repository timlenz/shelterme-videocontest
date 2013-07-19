# == Schema Information
#
# Table name: videos
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  category_id  :integer
#  approved     :boolean         default(FALSE)
#  length       :float
#  views_count  :integer         default(0), not null
#  shares_count :integer         default(0), not null
#  votes_count  :integer         default(0), not null
#

require 'spec_helper'

describe Video do
  pending "add some examples to (or delete) #{__FILE__}"
end
