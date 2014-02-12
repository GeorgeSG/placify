module Placify
  class JSONController < Base
    NAMESPACE = '/json'.freeze

    get '/points.json' do
      content_type :json
      POI.create(name: 'О шипка 2', type: 'Restaurant', description: "O shipka", lat: 42.294, lng: 23.332)
      POI.create(name: 'Марешки', type: 'Pharmacy', description: "qkata apteka", lat: 42.244, lng: 23.432)
      POI.create(name: 'BSD', type: 'Snooker', description: "bilqrdche brat", lat: 42.214, lng: 23.137)
      {markers: POI.all}.to_json
    end
  end
end
