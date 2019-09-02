class Parser
  def self.parse_user_name(html)
    Nokogiri::HTML.parse(html)
                  .at_css('a[href$="/lists"]')[:href][%r{(?<=/).*(?=/)}]
  end

  def self.parse_mypage(html, user_name)
    doc = Nokogiri::HTML.parse(html)
    following_size      = doc.at_css(%(a[href="/#{user_name}/following"] > span > span)).text.to_i
    followers_size      = doc.at_css(%(a[href="/#{user_name}/followers"] > span > span)).text.to_i
    notifications_count = doc.at_css('a[href="/notifications"]')['aria-label'][/(?<=通知（)\d+(?=件の未読通知）)/].to_i
    { following_size: following_size, followers_size: followers_size, notifications_count: notifications_count }
  end

  def self.parse_follower_list_page(html)
    doc = Nokogiri::HTML.parse(html)
    follower_list = doc.css('div[aria-label="タイムライン: フォロワー"] > div > div > div > div[class] > div[tabindex]').map do |node|
      split_text = node.text.split(/フォローされています|フォロー中|フォロー|未承認/).reject(&:empty?)
      user_name       = split_text[0].split('@')[-1]
      name            = split_text[0].gsub(/@#{user_name}$/, '')
      profile         = split_text.reject { |text| text.match?(/フォローされています|フォロー中|フォロー|未承認/) }[1..-1]
                                  .join.gsub('@', '★')
      icon_url        = node.at_css('img[src]')[:src]
      { user_name: user_name, name: name, profile: profile, icon_url: icon_url }
    end
    follower_list
  end
end
