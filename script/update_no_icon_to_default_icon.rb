require_relative './../common.rb'
default_icon = File.open(File.expand_path('../public/default_icon.png', __dir__)).read
Profile.where('user_profile_image IS NULL OR user_profile_image = ""').each do |profile|
  profile.user_profile_image = default_icon
  profile.save
end
