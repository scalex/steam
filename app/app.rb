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

    register Sinatra::Auth::Github

    get '/' do
      render_index
    end

    get '/login' do
      github_organization_authenticate!(settings.github_options[:organization])
      redirect '/'
    end

    get '/logout' do
      logout!
      redirect '/'
    end

    get '/specimens/new' do
      specimen = Specimen.new
      render_form specimen
    end

    post '/specimens' do
      specimen = Specimen.new
      specimen = Specimen::Creator.new(specimen).call params
      render_form specimen
    end

    get '/specimens/:nick/edit' do
      specimen = Specimen[params[:nick]]
      render_form specimen
    end

    post '/specimens/:nick' do
      specimen = Specimen[params[:nick]]
      specimen = Specimen::Updater.new(specimen).call params
      render_form specimen
    end

    post '/specimen/:nick/gimmick' do
      if params[:gimmick] && params[:gimmick].length > 0
        specimen = Specimen[params[:nick]]
        specimen[:gimmicks] = Hash(specimen[:gimmicks]).merge({ params[:gimmick].intern => 1 })
        specimen.save
      end
      redirect '/'
    end

    post '/specimen/:nick/foto' do
      content_type :json
      File.open("#{params[:file][:filename]}", 'w') do |f|
        f.write params[:file][:tempfile].read
      end
      { foo: 'bar' }.to_json
    end

    private

    def render_form specimen
      slim :form, {}, { specimen: specimen }
    end

    def render_index
      slim :index
    end
  end
end
