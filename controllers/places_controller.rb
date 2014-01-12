module Placify
  class PlacesController < Base
    NAMESPACE = '/places'

    get '/' do
      erb :'places/index'
    end
  end
end
