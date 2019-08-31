class Handler
  def initialize
    @crawler = Crawler.new
    mail     = ENV['TWITTER_MAIL']
    password = ENV['TWITTER_PASSWORD']
    @user_name = @crawler.login(mail, password)
                         .then { |page| Parser.parse_user_name(page[:html]) }
    @crawler.user_name = @user_name
  end

  def store_follower_list
    mypage      = @crawler.crawl_my_page
    mypage_info = Parser.parse_mypage(mypage[:html], @user_name)
    follower_profiles  = []
    follower_list_page = @crawler.crawl_follower_list_first_page
    Parser.parse_follower_list_page(follower_list_page[:html])
          .each { |profile| follower_profiles << profile }
    while follower_profiles.size < mypage_info[:followers_size]
      @crawler.scroll_follower_list_page
              .then { |page| Parser.parse_follower_list_page(page[:html]) }
              .each { |profile| follower_profiles << profile }
      follower_profiles.uniq! # うーん
    end
    follower_profiles.each do |follower_profile|
      user = if User.where(user_name: follower_profile[:user_name]).empty?
               User.create(user_name: follower_profile[:user_name])
             else
               User.where(user_name: follower_profile[:user_name]).first
             end
      if user.profiles.where(profile: follower_profile[:profile]).empty?
        user.profiles.create(follower_profile)
      end
    end
  end

  def tweet_profile_diff
    Profile.where('? < created_at', 1.hour.ago).each_with_index do |record, i|
      text = "Bioが更新されました!(#{i+1})\n"
      text += "#{record.user_name}: #{record.profile.strip}"[0..120]
      @crawler.tweet(text)
    end
  end

  at_exit do
    @crawler&.quit
  end
end
