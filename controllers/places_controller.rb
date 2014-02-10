module Placify
  class PlacesController < Base
    NAMESPACE = '/places'

    helpers UserHelpers

    get '/' do
      erb :'places/index'
    end
  end
end
