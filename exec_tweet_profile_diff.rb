# 毎日1回実行して，更新されたプロフィールを呟く
require_relative './common.rb'

handler = Handler.new

handler.tweet_profile_diff
