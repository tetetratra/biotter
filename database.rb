ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'twitter_bio_crawler',
  host: 'localhost',
  username: 'root',
  password: '',
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
