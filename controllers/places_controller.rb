module Placify
  class PlacesController < Base
    NAMESPACE = '/places'.freeze

    helpers UserHelpers

    get '/' do
      erb :'places/index'
    end

    get '/:point_id' do
      @point = Poi.where(id: params[:point_id]).first
      redirect '/', error: 'There is no such point in the database' if @point.nil?

      @title = @point.name
      erb :'places/view'
    end

    post '/search' do
      redirect NAMESPACE + '/search/' + params[:search_query]
    end

    get '/search/type/:search_query' do
      redirect '/' if params[:search_query].nil?

      search_query = Regexp.new(params[:search_query], true)
      @global_pois = Poi.or({type: search_query}).to_a

      unless logged_user.nil?
        @user_pois = logged_user.userPois.or({type: search_query}).to_a
      end

      erb :'places/search'
    end

    get '/search/:search_query' do
      redirect '/' if params[:search_query].nil?

      search_query = Regexp.new(params[:search_query], true)
      @global_pois = Poi.or({name: search_query}, {type: search_query}).to_a

      unless logged_user.nil?
        @user_pois = logged_user.userPois.or({name: search_query}, {type: search_query}).to_a
      end

      erb :'places/search'
    end
  end
end
