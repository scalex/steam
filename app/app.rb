module Steam
  class App < Sinatra::Base
    get '/' do
      'Hello World!'
    end
  end
end
