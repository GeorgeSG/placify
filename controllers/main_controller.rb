module Placify
  class MainController < Base
    NAMESPACE = '/'
    get '/' do
      erb :'home/index'
    end

    get '/about' do
      erb :'home/about'
    end
  end
end
