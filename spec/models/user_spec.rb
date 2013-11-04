# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  city                   :string(255)
#  bio                    :text
#  slug                   :string(255)
#  avatar                 :string(255)
#  admin                  :boolean         default(FALSE)
#  password_digest        :string(255)
#  remember_token         :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  date_of_birth          :datetime
#  phone                  :string(255)
#  zipcode                :string(255)
#  street                 :string(255)
#  state                  :string(255)
#  plays_count            :integer         default(0), not null
#  shares_count           :integer         default(0), not null
#  votes_count            :integer         default(0), not null
#  videos_count           :integer         default(0), not null
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
