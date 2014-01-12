module Placify
  class MainController < Base
    NAMESPACE = '/'
    get '/' do
      erb :'home/index'
    end
  end
end
