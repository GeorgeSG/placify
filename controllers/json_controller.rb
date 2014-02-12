module Placify
  class JSONController < Base
    NAMESPACE = '/json'.freeze

    get '/points.json' do
      content_type :json
      {markers: POI.all}.to_json
    end

    get '/types.json' do
      content_type :json
      {types: POI.all.map(&:type).uniq}.to_json
    end

    get '/extras.json' do
      content_type :json
      {extras: Extra.all.map(*:name).uniq}.to_json
    end
  end
end
