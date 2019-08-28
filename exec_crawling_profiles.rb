# 毎日1回実行して，DBに結果を入れる．
require_relative './common.rb'

handler = Handler.new
handler.store_follower_list
