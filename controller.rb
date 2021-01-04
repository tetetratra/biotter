require_relative './common.rb'
require "csv"

configure { set :server, :puma }

class Controller < Sinatra::Base
  # helpers Kaminari::Helpers::SinatraHelpers
  register Kaminari::Helpers::SinatraHelpers

  def initialize
    super
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  get '/' do
    @all_profiles = Profile.all.order(created_at: 'DESC').page(params['page']).per(20)
    erb :index
  end

  get '/:user_name' do
    users = Profile.select(:user_id).distinct.where(user_screen_name: params['user_name']).map(&:user) # (スクリーンネーム同じ & 別アカウント)用
    if users.empty?.! # (スクリーンネーム別 & 同一アカウント)用
      # スクリーンネームが変わった人のため
      profiles_all = users.flat_map(&:profiles).sort_by(&:created_at).reverse
      @profiles = Kaminari.paginate_array(profiles_all).page(params['page']).per(20)
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

  get '/:user_name/download' do
    user_screen_name = params['user_name']
    users = Profile.select(:user_id).distinct.where(user_screen_name: user_screen_name).map(&:user) # (スクリーンネーム同じ & 別アカウント)用
    if users.empty?.! # (スクリーンネーム別 & 同一アカウント)用
      # スクリーンネームが変わった人のため
      profiles_all = users.flat_map(&:profiles).sort_by(&:created_at).reverse

      zip_file = Tempfile.open
      bom = "\uFEFF"
      zip_file.write(bom)
      Zip::File.open(zip_file.path, Zip::File::CREATE) do |zipfile|
        csv_header = %i[id user_screen_name user_name user_description user_location user_url created_at]
        Tempfile.open do |file|
          CSV.open(file.path, 'wb') do |csv|
            csv << csv_header
            profiles_all.each do |profile|
              csv << csv_header.map { |h| profile[h] }
            end
          end
          zipfile.add('profiles.csv', file.path)
        end

        profiles_all.each do |profile|
          Tempfile.open do |file|
            next if profile[:user_profile_image].nil?

            file.write(profile[:user_profile_image])
            zipfile.add("icons/#{profile.id}.png", file.path)
          end

          Tempfile.open do |file|
            next if profile[:user_profile_banner].nil?

            file.write(profile[:user_profile_banner])
            zipfile.add("banners/#{profile.id}.png", file.path)
          end
        end
      end
      send_file(zip_file.path, filename: "biotter_archive_#{user_screen_name}.zip")
      zip_file.close
    else
      @not_found_user_name = params['user_name']
      erb :not_found_user_page
    end
  end

  run! if app_file == $PROGRAM_NAME # Rubyファイルが直接実行されたらサーバを立ち上げる
end
