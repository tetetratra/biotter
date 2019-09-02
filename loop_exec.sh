while true; do
  echo "exec start"
  bundle exec ruby exec.rb
  echo "exec finish"
  sleep 3600
done
