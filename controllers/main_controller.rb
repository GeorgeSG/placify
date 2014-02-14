module Placify
  class MainController < Base
    NAMESPACE = '/'.freeze

    helpers UserHelpers

    get '/' do
      erb :'home/index'
    end

    get '/about' do
      @title = 'About Placify'
      erb :'home/about'
    end
  end
end
