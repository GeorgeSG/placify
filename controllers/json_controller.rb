module Placify
  class JSONController < Base
    NAMESPACE = '/json'.freeze

    helpers UserHelpers

    get '/points.json' do
      content_type :json
      {markers: POI.all}.to_json
    end

    post '/addNewPoint/:id' do
      content_type :json

      poi = UserPOI.new(
        name: params[:name],
        type: params[:type],
        lat: params[:lat],
        lng: params[:lng],
        description: params[:desc]
      )

      user = User.where(id: params[:id]).first
      poi.user = user
      poi.save

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
