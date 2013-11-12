task calculate_votes_quartile: :environment do
  votes_sql = "select id, ntile(4) over (order by votes_count) from videos"
  sq = ActiveRecord::Base.connection.execute(votes_sql)
  Video.all.each{|v| v.update_attribute(:votes_quartile, sq.select{|q| q["id"] == v.id.to_s}.map{|q| q["ntile"]}[0])}
end

task calculate_plays_quartile: :environment do
  plays_sql = "select id, ntile(4) over (order by plays_count) from videos"
  sq = ActiveRecord::Base.connection.execute(plays_sql)
  Video.all.each{|v| v.update_attribute(:plays_quartile, sq.select{|q| q["id"] == v.id.to_s}.map{|q| q["ntile"]}[0])}
end

task calculate_shares_quartile: :environment do
  shares_sql = "select id, ntile(4) over (order by shares_count) from videos"
  sq = ActiveRecord::Base.connection.execute(shares_sql)
  Video.all.each{|v| v.update_attribute(:shares_quartile, sq.select{|q| q["id"] == v.id.to_s}.map{|q| q["ntile"]}[0])}
end

task calculate_rating: :environment do
  Video.all.each{|v| v.update_attribute(:rating, ((v.shares_quartile + v.plays_quartile + v.votes_quartile / 2 + 0.4 * v.ave_vote) / 3).round(2) )}
end