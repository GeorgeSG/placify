class Extra
  include Mongoid::Document
  field :name, type: String
  field :details, type: Hash

  validates_presence_of :name, message: 'You must provide a name'
  has_and_belongs_to_many :pois
end
