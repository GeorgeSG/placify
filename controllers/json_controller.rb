module Placify
  class JSONController < Base
    NAMESPACE = '/json'.freeze

    get '/points.json' do
      content_type :json
      {markers: POI.all}.to_json
    end
  end
end
