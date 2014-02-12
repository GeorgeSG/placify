class POI
  include Mongoid::Document
  field :name,        type: String
  field :lat,         type: Float
  field :lng,         type: Float
  field :rating,      type: Float, default: 0.0
  field :description, type: String
  field :shedule,     type: Hash

  validates_presence_of :name
  validates_presence_of :lat
  validates_presence_of :lng

  validates_numericality_of :rating, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0
end
