class User
  include Mongoid::Document
  field :username, type: String
  field :password, type: String
  field :salt,     type: String

  field :first_name, type: String
  field :last_name,  type: String

  has_and_belongs_to_many :pois, inverse_of: nil

  #validates_presence_of :username
  #validates_presence_of :password

  #validates_format_of :username, with: /[a-z0-9]\w.*@[a-z0-9]\w.*\.[a-z]{2,6}/

  #validates_uniqueness_of :username, message: 'not unique username'

  #validates :password, length: { minimum: 6, maximum: 16 } 
  #too_short: 'the password must be between 6 and 16 symbols', 
  #too_long: 'the password must be between 6 and 16 symbols'

  index({ username: 1 }, { unique: true, name: "username_index" })
end
