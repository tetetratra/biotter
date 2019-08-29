require_relative './common.rb'
class Controller < Sinatra::Base
  def initialize
    super
  end

  get '/' do
    erb :index
  end

  get '/:user_name' do
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
