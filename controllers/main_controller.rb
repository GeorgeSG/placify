module Placify
  class MainController < Base
    NAMESPACE = '/'.freeze

    helpers UserHelpers

    get '/' do
      @top_viewed = Poi.top_viewed_places
      @last_added = Poi.last_added
      point_likes = {}

      Poi.each { |point|  point_likes[point] = point.users.size }
      @top_liked = Hash[point_likes.sort_by { |key, value| value }.reverse].keys[0...5].to_a

      erb :'home/index'
    end

    get '/about' do
      @title = 'About Placify'
      erb :'home/about'
    end
  end
end
