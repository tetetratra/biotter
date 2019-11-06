require_relative './common.rb'
consumer_key        = ENV['BIOTTER_CONSUMER_KEY']
consumer_secret     = ENV['BIOTTER_CONSUMER_SECRET']
access_token        = ENV['BIOTTER_ACCESS_TOKEN']
access_token_secret = ENV['BIOTTER_ACCESS_TOKEN_SECRET']

handler = Handler.new(consumer_key, consumer_secret, access_token, access_token_secret)

follower_profiles = handler.fetch_follower_profiles
#updated_follower_profiles = handler.select_updated_follower_profiles(follower_profiles)
updated_follower_profiles = follower_profiles
handler.create_follower_profiles(updated_follower_profiles)
handler.tweet_follower_profiles(updated_follower_profiles)
