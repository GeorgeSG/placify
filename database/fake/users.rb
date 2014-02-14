require './fake_helpers'
require 'bcrypt'

User.delete_all

10.times do
  first_name = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  home_lat   = Faker::Address.longitude
  home_lng   = Faker::Address.latitude
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(first_name, password_salt)

  User.create(
    username: first_name,
    password: password_hash,
    salt: password_salt,
    first_name: first_name,
    last_name: last_name,
    home_lat: home_lat,
    home_lng: home_lng
  )
end
