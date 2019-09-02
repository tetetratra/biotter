require_relative './common.rb'
handler = Handler.new
handler.store_follower_list
handler.tweet_profile_diff unless $silent_flag
