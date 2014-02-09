require 'rubygems'
require 'bundler/setup'

module Placify
  Bundler.require :default

  class Base < Sinatra::Base
    register Sinatra::ConfigFile
    config_file 'config.yml'

    set :views,         File.expand_path(settings.views_path,  __FILE__)
    set :public_folder, File.expand_path(settings.public_path, __FILE__)

    enable :sessions

    configure :development do
      Mongoid.configure do
        name = 'placify'
        host = 'localhost'
      end
    end

  end
end

Dir.glob('./controllers/**/*.rb').each do |controller|
  require controller
end

controllers = [
  Placify::MainController,
  Placify::PlacesController,
]

controllers.each do |controller|
  map(controller::NAMESPACE) { run controller }
end
