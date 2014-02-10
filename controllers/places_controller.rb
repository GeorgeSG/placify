module Placify
  class PlacesController < Base
    NAMESPACE = '/places'.freeze

    helpers UserHelpers

    get '/' do
      erb :'places/index'
    end
  end
end
