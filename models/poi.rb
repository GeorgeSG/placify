class Poi
  include Mongoid::Document
  field :name,        type: String
  field :type,        type: String
  field :description, type: String
  field :lng,         type: Float
  field :lat,         type: Float
  field :rating,      type: Float, default: 0.0
  field :views,       type: Integer, default: 0
  field :shedule,     type: Hash
  field :priceRange,  type: String
  field :seats,       type: Integer

  has_and_belongs_to_many :extras
  has_and_belongs_to_many :users

  validates_presence_of :name, message: 'You must provide a name for the point'
  validates_presence_of :type, message: 'You must provide a type for the point'
  validates_presence_of :lng, message: 'You must provide longitude for the point'
  validates_presence_of :lat, message: 'You must provide latitude for the point'


  validates_numericality_of :rating, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0,
    message: 'The rating of the point must be between 0 and 5'

  #index({  }, { min: -200, max: 200 })

  def self.types
    [:pharmacy, :restaurant, :hotel, :billiard, :snooker, :casino, :supermarket, :cinema, :bookstore, :mall]
  end

  def self.top_viewed_places
    Poi.order_by([[:views, :desc]]).limit(5)
  end

  def self.last_added
    Poi.order_by([[:_id, :desc]]).limit(5)
  end
end

class UserPoi < Poi
  embedded_in :user
end

