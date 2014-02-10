require 'rubygems'
require 'bundler/setup'

module Placify
  Bundler.require :default

  class Base < Sinatra::Base
    use Rack::Flash
    register Sinatra::ConfigFile
    register Sinatra::Partial

    helpers Sinatra::RedirectWithFlash

    enable :sessions

    config_file 'config/config.yml'

    set :views,         File.expand_path(settings.views_path,  __FILE__)
    set :public_folder, File.expand_path(settings.public_path, __FILE__)
    set :partial_template_engine, :erb

    Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")))
  end
end

Dir.glob('./models/**/*.rb').each      { |model| require model }
Dir.glob('./helpers/**/*.rb').each     { |helper| require helper }
Dir.glob('./controllers/**/*.rb').each { |controller| require controller }

controllers = [
  Placify::MainController,
  Placify::PlacesController,
  Placify::AuthController,
]

controllers.each do |controller|
  map(controller::NAMESPACE) { run controller }
end
