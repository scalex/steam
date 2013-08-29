module Steam
  class App < Sinatra::Base
    get '/' do
      slim :index
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
  end
end
