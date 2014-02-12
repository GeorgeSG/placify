module Placify
  class JSONController < Base
    NAMESPACE = '/json'.freeze

    helpers UserHelpers

    get '/points.json' do
      content_type :json
      {markers: POI.all}.to_json
    end

    get '/userPoints.json/:id' do
      content_type :json

      user = User.where(id: params[:id]).first
      {markers: user.userPOIs}.to_json
    end

    get '/types.json' do
      content_type :json
      {types: POI.all.map(&:type).uniq}.to_json
    end

    get '/extras.json' do
      content_type :json
      {extras: Extra.all.map(*:name).uniq}.to_json
    end

    get '/loggedUser.json' do
      content_type :json
      if logged?
        {id: logged_user.id}.to_json
      else
        {id: nil}.to_json
      end
    end
  end
end
