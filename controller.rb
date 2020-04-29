require_relative './common.rb'

configure { set :server, :puma }

class Controller < Sinatra::Base
  def initialize
    super
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  get '/' do
    @all_profiles = Profile.all.order(created_at: 'DESC')
    erb :index
  end

  get '/:user_name' do
    pre_profiles = Profile.where(user_screen_name: params['user_name'])
    if pre_profiles.empty?.!
      @profiles = pre_profiles.flat_map { |pro| pro.user.profiles }.sort_by { |pro| pro.created_at }.reverse.uniq
      erb :user_page
    else
      @not_found_user_name = params['user_name']
      erb :not_found_user_page
    end
  end

  not_found do
    '無効なURLです...'
  end

  error do
    # なんかログを残したい
    'なにかエラーが発生しました...'
  end

  run! if app_file == $PROGRAM_NAME # Rubyファイルが直接実行されたらサーバを立ち上げる
end
