module Steam
  class App < Sinatra::Base
    get '/' do
      slim :index
    end
  end
end
