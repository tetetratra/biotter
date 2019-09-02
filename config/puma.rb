root = Dir.getwd.to_s
case `hostname -f`
when /MacBook.*local/
  bind 'tcp://127.0.0.1:8100'
when /sakura\.ne\.jp/
  bind 'tcp://0.0.0.0:7890'
end
pidfile "#{root}/tmp/puma/pid"
state_path "#{root}/tmp/puma/state"
rackup "#{root}/config.ru"
threads 1, 8
activate_control_app
