module Placify
  class PlacesController < Base
    NAMESPACE = '/places'.freeze

    helpers UserHelpers

    get '/' do
      erb :'places/index'
    end

    get '/test', auth: :logged do
      erb 'you are logged!'
    end

    post '/addPoint' do

    end
  end
end
