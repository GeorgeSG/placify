#!/usr/bin/env ruby

require 'rubygems'
require 'bson'
require 'faker'
require 'mongoid'

Dir.glob('../../models/**/*.rb').each { |model| require model }
Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__), :development)
