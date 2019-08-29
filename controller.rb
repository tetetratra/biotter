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
    binding.pry
    if @user
      erb :user_page
    else
      @not_found_user_name = params['user_name']
      erb :not_found_user_page
    end
  end

  # error do
  #   'エラーが発生しました。 - ' + env['sinatra.error'].message
  # end

  run! if app_file == $PROGRAM_NAME # Rubyファイルが直接実行されたらサーバを立ち上げる
end
