while true; do
  echo "exec start"
  bundle exec ruby exec_crawling_profiles.rb
  bundle exec ruby exec_tweet_profile_diff.rb
  echo "exec finish"
  sleep 3600
done
