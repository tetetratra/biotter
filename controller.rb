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

  get '/biotter' do
    erb :index
  end

  get '/biotter/:user_name' do
    @user = User.where(user_name: params['user_name']).first
    if @user
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
