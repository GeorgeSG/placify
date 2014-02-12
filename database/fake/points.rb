#!/usr/bin/env ruby

require 'rubygems'
require 'bson'
require 'faker'
require 'mongoid'


Dir.glob('../../models/**/*.rb').each      { |model| require model }
Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__), :development)


POI.delete_all
100.times do
  name = Faker::Name.name
  desc = Faker::Lorem.paragraph(10)
  POI.create(
    name: name,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    description: "<h3>#{name}</h3><p>#{desc}"
  )
end
