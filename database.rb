case `hostname -f`
when /MacBook.*local/
  db_username = 'root'
  db_password = ''
when /sakura\.ne\.jp/
  db_username = 'biotter'
  db_password = 'biotter_pass'
end

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'biotter',
  host: 'localhost',
  username: db_username,
  password: db_password,
  charset: 'utf8mb4',
  encoding: 'utf8mb4',
  collation: 'utf8mb4_general_ci'
)

Time.zone_default = Time.find_zone! 'Tokyo'
ActiveRecord::Base.default_timezone = :local

ActiveRecord::Base.logger = Logger.new(STDOUT)

class User < ActiveRecord::Base
  has_many :profiles
end

class Profile < ActiveRecord::Base
  belongs_to :user
end
