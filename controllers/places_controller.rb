module Placify
  class PlacesController < Base
    NAMESPACE = '/places'.freeze

    helpers UserHelpers

    get '/' do
      erb :'places/index'
    end

    get '/:point_id' do
      @point = POI.where(id: params[:point_id]).first
      redirect '/', error: 'There is no such point in the database' if @point.nil?

      @title = @point.name
      erb :'places/view'
    end
  end
end
