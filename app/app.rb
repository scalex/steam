Bundler.require

require 'sinatra/asset_pipeline'
require 'services/specimen/updater'
require 'services/specimen/creator'

module Steam
  class App < Sinatra::Base
    set :assets_precompile, %w(app.js app.css *.svg *.eot *.ttf *.woff)
    set :assets_prefix, %w(app/assets vendor/assets)
    set :assets_css_compressor, :sass
    set :assets_js_compressor, :uglifier

    register Sinatra::AssetPipeline

    enable :sessions

    class BadSteam < Sinatra::Base
      enable :raise_errors
      disable :show_exceptions

      helpers do
        def unauthorized_template
          @unauthenticated_template ||= slim :unauthenticated, layout: false
        end
      end

      get '/unauthenticated' do
        env['warden'].logout if env['warden']
        status 403
        unauthorized_template
      end
    end

    use BadSteam

    set :github_options, {
      scopes: 'user',
      secret: ENV['GITHUB_CLIENT_SECRET'],
      client_id: ENV['GITHUB_CLIENT_ID'],
      organization: ENV['GITHUB_ORG'],
      failure_app: BadSteam,
    }

    set :public_folder, Proc.new { File.join(root, 'public') }

    register Sinatra::Auth::Github

    get '/' do
      render_index
    end

    get '/login' do
      github_auth!
      redirect '/'
    end

    get '/logout' do
      logout!
      redirect '/'
    end

    get '/new' do
      github_auth!
      specimen = Specimen.new
      render_form specimen
    end

    post '/create' do
      github_auth!
      specimen = Specimen.new
      specimen = Specimen::Creator.new(specimen).call params
      render_form specimen
    end

    get '/:nick/edit' do
      github_auth!
      specimen = Specimen[params[:nick]]
      render_form specimen
    end

    post '/:nick/update' do
      github_auth!
      specimen = Specimen[params[:nick]]
      specimen = Specimen::Updater.new(specimen).call params
      redirect "/#{params[:nick]}/edit"
    end

    post '/:nick/gimmick' do
      github_auth!
      specimen = Specimen[params[:nick]]
      specimen = Specimen::Updater.new(specimen).call params
      redirect '/'
    end

    post '/:nick/foto' do
      github_auth!
      content_type :json
      file_name = params[:file][:filename]
      File.open("#{public_folder}/#{file_name}", 'w') do |file|
        file.write params[:file][:tempfile].read
        specimen = Specimen[params[:nick]]
        specimen = Specimen::Updater.new(specimen).call foto: file_name
      end
      { url: file_name }.to_json
    end

    private

    def guess_icon link
      if link =~ /twitter/
        'twitter'
      elsif link =~ /github/
        'github'
      elsif link =~ /facebook/
        'facebook'
      elsif link =~ /github/
        'github'
      elsif link =~ /stack-overflow/
        'stack-overflow'
      else
        'caret-right'
      end
    end

    def render_form specimen
      slim :form, {}, { specimen: specimen }
    end

    def render_index
      slim :index
    end

    def github_auth!
      github_organization_authenticate!(settings.github_options[:organization])
    end

    def public_folder
      settings.public_folder
    end
  end
end
