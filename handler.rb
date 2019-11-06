class Handler
  def initialize(consumer_key, consumer_secret, access_token, access_token_secret)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end

  def fetch_follower_profiles
    follower_profiles = @client.followers.map(&:to_h).map do |follower|
      url_master = ((follower[:entities][:url] && follower[:entities][:url][:urls]).to_a + follower[:entities][:description][:urls]).map { |url| [url[:url], url[:expanded_url]] }

      user_twitter_id        = follower[:id]
      user_screen_name       = follower[:screen_name]
      user_name              = follower[:name]
      user_profile_image_url = follower[:profile_image_url].gsub('_normal', '_200x200').split('/')[-2..-1].join('_')
      user_description       = follower[:description]
                               .then do |description|
                                 url_master.inject(description) do |new_description, (short_url, full_url)|
                                   new_description.gsub(short_url, full_url)
                                 end
                               end
      user_url               = follower[:url]
                               .then do |url|
                                 url_master.inject(url) do |new_url, (short_url, full_url)|
                                   new_url.gsub(short_url, full_url)
                                 end
                               end
      {
        user_twitter_id: user_twitter_id,
        user_screen_name: user_screen_name,
        user_name: user_name,
        user_profile_image_url: user_profile_image_url,
        user_description: user_description,
        user_url: user_url
      }
    end
    follower_profiles
  end

  def select_updated_follower_profiles(follower_profiles)
    # "違い"とみなす項目
    compare_target_colmn = %i[user_description user_screen_name user_name user_profile_image_url]
    selected_follower_profiles = follower_profiles.select do |follower_profile|
      user = User.find_by(user_twitter_id: follower_profile[:user_twitter_id])
      user.nil? || user.profiles.first&.slice(*compare_target_colmn)&.symbolize_keys != follower_profile.slice(*compare_target_colmn)
    end
    selected_follower_profiles
  end

  def create_follower_profiles(follower_profiles)
    follower_profiles.each do |follower_profile|
      user = User.find_by(user_twitter_id: follower_profile[:user_twitter_id]) || User.create(user_twitter_id: follower_profile[:user_twitter_id])
      user.profiles.create(follower_profile)
      Dir.mkdir("public/images/#{follower_profile[:user_twitter_id]}") if Dir.glob("public/images/#{follower_profile[:user_twitter_id]}").empty?
      File.open("public/images/#{follower_profile[:user_twitter_id]}/#{follower_profile[:user_profile_image_url]}", 'wb') do |file|
        uri = URI.parse(follower_profile[:user_profile_image_url])
        request = Net::HTTP::Get.new(uri)
        request['Upgrade-Insecure-Requests'] = '1'
        request['Sec-Fetch-Mode'] = 'navigate'
        request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3'
        req_options = { use_ssl: uri.scheme == 'https' }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        image = response.body
        file.write(image)
      end
    end
  end

  def tweet_follower_profiles(follower_profiles)
    follower_profiles.each do |follower_profile|
      safe_description = follower_profile[:user_description].gsub(/@|#/, '*')
      tweet_str = "#{follower_profile[:user_name]}さん(#{follower_profile[:user_screen_name]})のプロフィールが更新されました!\n #{safe_description}"\
                  + "\nhttp://tetetratra.net/biotter/#{follower_profile[:user_screen_name]}"
      puts tweet_str
      # @client.update(tweet_str)
    end
  end
end
