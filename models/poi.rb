class POI
  include Mongoid::Document
  field :name,        type: String
  field :type,        type: String
  field :description, type: String
  field :lng,         type: Float
  field :lat,         type: Float
  field :rating,      type: Float, default: 0.0
  field :views,       type: Integer, default: 0
  field :shedule,     type: Hash

  has_and_belongs_to_many :extras

  validates_presence_of :name, message: 'You must provide a name for the point'
  validates_presence_of :type, message: 'You must provide a type for the point'
  validates_presence_of :lng, message: 'You must provide longitude for the point'
  validates_presence_of :lat, message: 'You must provide latitude for the point'


  validates_numericality_of :rating, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0,
    message: 'The rating of the point must be between 0 and 5'

  #index({  }, { min: -200, max: 200 })

  def self.types
    @types = [:cinema, :restaurant, :pharmacy, :hotel, :bookstore, :mall, :store,]
  end
end

class UserPOI < POI
  embedded_in :user
end

