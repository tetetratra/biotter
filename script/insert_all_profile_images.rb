require_relative './../common.rb'

Profile.where('user_profile_image_url IS NOT NULL').each do |profile|
  image_path = File.expand_path('../public/images/' + profile.user_twitter_id.to_s + '/' + profile.user_profile_image_url.gsub('/', ''), __dir__)
  begin
    image = File.open(image_path)
  rescue
    next
  end
  profile.user_profile_image = image.read
  profile.save
end

