require_relative './../common.rb'

Profile.where('user_profile_image_url IS NOT NULL').each do |profile|
  image_path = './../images/' + profile.user_twitter_id.to_s + '/' + profile.user_profile_image_url.gsub('/', '')
  image = File.open(image_path)
  profile.user_profile_image = image.read
  profile.save!
end

