module Placify
  class JSONController < Base
    NAMESPACE = '/json'.freeze

    helpers UserHelpers

    get '/points.json' do
      content_type :json
      {markers: POI.all}.to_json
    end

    post '/updatePoint/:point_id' do
      content_type :json
      return nil if logged_user.nil?

      poi_hash = {id: params[:point_id]}
      if logged_user.admin
        poi = POI.where(poi_hash).first
      else
        poi = logged_user.userPOIs.where(poi_hash).first
      end

      poi.name = params[:name];
      poi.type = params[:type];
      poi.lat = params[:lat];
      poi.lng = params[:lng];
      poi.description = params[:desc]

      poi.save
      nil
    end

    post '/addNewPoint/:user_id' do
      content_type :json
      user = User.where(id: params[:user_id]).first
      return nil if user.nil?

      poi_hash = {name: params[:name],
                  type: params[:type],
                  lat: params[:lat],
                  lng: params[:lng],
                  description: params[:desc]}

      if user.admin
        poi = POI.new(poi_hash)
      else
        poi = UserPOI.new(poi_hash)
        poi.user = user
      end

      poi.save
      nil
    end

    post '/updateViews/:point_id' do
      point = POI.where(id: params[:point_id]).first
      return nil if point.nil?

      point.views = point.views + 1
      point.save
      nil
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

    get '/userTypes.json/:id' do
      content_type :json

      user = User.where(id: params[:id]).first
      {types: user.userPOIs.map(&:type).uniq}.to_json
    end

    get '/extras.json' do
      content_type :json
      {extras: Extra.all.map(&:name).uniq}.to_json
    end

    get '/loggedUser.json' do
      content_type :json
      if logged?
        {id: logged_user.id}.to_json
      else
        {id: nil}.to_json
      end
    end

    get '/adminUser.json' do
      content_type :json
      {admin: admin?}.to_json
    end

    get '/getHome.json/:user_id' do
      content_type :json

      user = User.where(id: params[:user_id]).first
      return nil if user.nil?

      {lat: user.home_lat, lng: user.home_lng}.to_json
    end

    post '/setHome/:user_id' do
      user = User.where(id: params[:user_id]).first
      user.home_lat = params[:lat]
      user.home_lng = params[:lng]
      user.save
      nil
    end
  end
end
