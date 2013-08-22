class StaticPagesController < ApplicationController
  def new
  end
  
  def statistics
    unless signed_in? && current_user.admin? 
      redirect_to root_path
    end
    
    # last week, by day
    recent_added_videos = Video.where(created_at: 7.days.ago.utc...Time.now.utc)
    recent_users = User.where(created_at: 7.days.ago.utc...Time.now.utc)
    recent_plays = Play.where(created_at: 7.days.ago.utc...Time.now.utc)
    # recent_shares = Share.where(created_at: 7.days.ago.utc...Time.now.utc)
    # recent_facebook_shares = Share.where(created_at: 7.days.ago.utc...Time.now.utc, share_type: 1) # Facebook
    # recent_twitter_shares = Share.where(created_at: 7.days.ago.utc...Time.now.utc, share_type: 2) # Twitter
    new_videos = []
    new_users = []
    new_plays = []
    new_shares = []
    new_facebook_shares = []
    new_twitter_shares = []
    7.times do |n|
      new_videos[n] = recent_added_videos.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
      new_users[n] = recent_users.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
      new_plays[n] = recent_plays.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
      # new_shares[n] = recent_shares.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
      # new_facebook_shares[n] = recent_facebook_shares.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
      # new_twitter_shares[n] = recent_twitter_shares.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    @new_videos = new_videos.reverse.join(',')
    @new_videos_count = new_videos.sum
    @new_users = new_users.reverse.join(',')
    @new_users_count = new_users.sum
    @new_plays = new_plays.reverse.join(',')
    @new_plays_count = new_plays.sum
    # @new_shares = new_shares.reverse.join(',')
    @new_shares_count = new_shares.sum
    # @new_facebook_shares = new_facebook_shares.reverse.join(',')
    @new_facebook_shares_count = new_facebook_shares.sum
    # @new_twitter_shares = new_twitter_shares.reverse.join(',')
    @new_twitter_shares_count = new_twitter_shares.sum
    
    # to date, by week
    added_videos = Video.all
    joined_users = User.all
    viewed_videos = Play.all
    # shared_videos = Share.all
    # facebook_shares = Share.where(share_type: 1) # Facebook
    # twitter_shares = Share.where(share_type: 2) # Twitter
    all_videos = []
    all_users = []
    all_plays = []
    all_shares = []
    all_facebook_shares = []
    all_twitter_shares = []
    start_date = Time.parse("Mon, 5 Aug 2013 9:00:00 PDT -07:00").utc
    running_weeks = ((Time.now.utc - start_date) / 604800)
    if running_weeks.modulo(1) > 0
      running_weeks = running_weeks.round + 1
    end
    running_weeks.times do |n|
      all_videos[n] = added_videos.select{|s| s.created_at >= (n+1).weeks.ago.beginning_of_week && s.created_at <= (n+1).weeks.ago.end_of_week}.size
      all_users[n] = joined_users.select{|s| s.created_at >= (n+1).weeks.ago.beginning_of_week && s.created_at <= (n+1).weeks.ago.end_of_week}.size
      all_plays[n] = viewed_videos.select{|s| s.created_at >= (n+1).weeks.ago.beginning_of_week && s.created_at <= (n+1).weeks.ago.end_of_week}.size
      # all_shares[n] = shared_videos.select{|s| s.created_at >= (n+1).weeks.ago.beginning_of_week && s.created_at <= (n+1).weeks.ago.end_of_week}.size
      # all_facebook_shares[n] = facebook_shares.select{|s| s.created_at >= (n+1).weeks.ago.beginning_of_week && s.created_at <= (n+1).weeks.ago.end_of_week}.size
      # all_twitter_shares[n] = twitter_shares.select{|s| s.created_at >= (n+1).weeks.ago.beginning_of_week && s.created_at <= (n+1).weeks.ago.end_of_week}.size
    end
    @all_videos = all_videos.reverse.join(',')
    @all_videos_count = all_videos.sum
    @all_users = all_users.reverse.join(',')
    @all_users_count = all_users.sum
    @all_plays = all_plays.reverse.join(',')
    @all_plays_count = all_plays.sum
    # @all_shares = all_shares.reverse.join(',')
    @all_shares_count = all_shares.sum
    # @all_facebook_shares = all_facebook_shares.reverse.join(',')
    @all_facebook_shares_count = all_facebook_shares.sum
    # @all_twitter_shares = all_twitter_shares.reverse.join(',')
    @all_twitter_shares_count = all_twitter_shares.sum
    
    # voting statistics: number, ave value, distribution
    # voting stats by video?
  end
end
