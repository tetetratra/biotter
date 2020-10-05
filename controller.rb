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
    @all_profiles = Profile.all.order(created_at: 'DESC').limit(20)
    erb :index
  end

  get '/:user_name' do
    users = Profile.select(:user_id).distinct.where(user_screen_name: params['user_name']).map(&:user) # (スクリーンネーム同じ & 別アカウント)用
    if users.empty?.! # (スクリーンネーム別 & 同一アカウント)用
      # スクリーンネームが変わった人のため
      @profiles = users.flat_map(&:profiles).sort_by(&:created_at).reverse
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
