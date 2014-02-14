class User
  include Mongoid::Document
  field :username, type: String
  field :password, type: String
  field :salt,     type: String

  field :first_name, type: String
  field :last_name,  type: String
  field :admin,      type: Boolean, default: false

  field :home_lat, type: Float
  field :home_lng, type: Float

  has_and_belongs_to_many :POIs, inverse_of: nil
  embeds_many :userPOIs

  validates_presence_of :username, message: 'You must provide an email for username'
  validates_presence_of :password, message: 'You must provide a password'

  #validates_format_of :username, with: /[a-z0-9]\w.*@[a-z0-9]\w.*\.[a-z]{2,6}/

  validates_uniqueness_of :username, message: 'A user with this username already exists'

  #validates :password, length: { minimum: 6, maximum: 16 }
  #too_short: 'the password must be between 6 and 16 symbols',
  #too_long: 'the password must be between 6 and 16 symbols'

  index({ username: 1 }, { unique: true, name: "username_index" })

end
