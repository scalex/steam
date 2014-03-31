module Steam
  class App < Sinatra::Base
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
      slim :index
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
      slim :form
    end

    post '/specimens' do
      specimen = Specimen.new
      specimen[:nick] = params[:nickname]
      specimen.save
      redirect '/'
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
  end
end
