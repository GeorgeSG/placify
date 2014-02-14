require './fake_helpers'

Poi.delete_all

100.times do
  name = Faker::Name.name
  desc = Faker::Lorem.paragraph(10)
  type = Poi.types.sample.to_s
  Poi.create(
    name: name,
    type: type,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    description: desc
  )
end
