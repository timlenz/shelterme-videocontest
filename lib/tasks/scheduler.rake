task calculate_rating: :environment do
  videos = Video.where(approved: true)
  # calculate_votes_quartile
  votes_sql = "select id, ntile(20) over (order by votes_count) from videos where approved = true"
  sq = ActiveRecord::Base.connection.execute(votes_sql)
  videos.each{|v| v.update_attribute(:votes_quartile, sq.select{|q| q["id"] == v.id.to_s}.map{|q| q["ntile"]}[0])}

 # calculate_plays_quartile
  plays_sql = "select id, ntile(20) over (order by plays_count) from videos where approved = true"
  sq = ActiveRecord::Base.connection.execute(plays_sql)
  videos.each{|v| v.update_attribute(:plays_quartile, sq.select{|q| q["id"] == v.id.to_s}.map{|q| q["ntile"]}[0])}

  # calculate_shares_quartile
  shares_sql = "select id, ntile(20) over (order by shares_count) from videos where approved = true"
  sq = ActiveRecord::Base.connection.execute(shares_sql)
  videos.each{|v| v.update_attribute(:shares_quartile, sq.select{|q| q["id"] == v.id.to_s}.map{|q| q["ntile"]}[0])}

  # calculate_rating
  videos.each{|v| v.update_attribute(:rating, ((v.shares_quartile * 0.2 + v.plays_quartile * 0.2 + (v.votes_quartile * 0.1) + (0.4 * v.ave_vote)) / 3).round(5) )}
end

task update_ave_vote: :environment do
  videos = Video.where(approved: true)
  videos.each{|v| v.calculate_ave_vote}
end