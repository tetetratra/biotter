class Crawler
  attr_accessor :driver
  attr_accessor :user_name

  def initialize
    ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'
    # caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => { args: ['--headless', '--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu', "--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
    caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => { args: ["--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
    @driver.manage.timeouts.implicit_wait = 10 # find_elementのタイムアウト時間
    @user_name = ''
  end

  def login(mail, password)
    @driver.navigate.to('https://twitter.com').tap { sleep 5 }
    at_css('input.text-input.email-input.js-signin-email').send_keys(mail)
    at_css('input.text-input[type="password"]:nth-child(1)').send_keys(password)
    at_css('input[type="submit"][value="ログイン"]').click.tap { sleep 5 }
    page
  end

  def crawl_my_page
    @driver.navigate.to("https://twitter.com/#{@user_name}").tap { sleep 5 }
    page
  end

  def crawl_follower_list_first_page
    @driver.navigate.to("https://twitter.com/#{@user_name}/followers").tap { sleep 5 }
    page
  end

  def scroll_follower_list_page
    js('window.scrollBy(0,1500)').tap { sleep 2 }
    page
  end

  def tweet(text)
    encoded_text = URI.encode_www_form_component(text)
    @driver.navigate.to("https://twitter.com/intent/tweet?text=#{encoded_text}").tap { sleep 5 }
    at_css('input[type="submit"][value="ツイート"]').click.tap { sleep 5 }
  end

  private

  def css(selector)
    @driver.find_elements(:css, selector)
  end

  def at_css(selector)
    @driver.find_element(:css, selector)
  end

  def page
    {
      html: @driver.page_source,
      url: @driver.current_url,
      title: @driver.title
    }
  end

  def js(str)
    @driver.execute_script(str)
  end
end
