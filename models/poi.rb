class Poi
  include Mongoid::Document
  field :name, type: String
  field :coordinates, type: Array
  field :rating, type: Float, default: 0.0
  field :description, type: String
  field :shedule, type: Hash

  validates_presence_of :name
  validates_presence_of :coordinates

  validates_numericality_of :rating, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0

  index({ coordinates: "2d" }, { min: -200, max: 200 })
end