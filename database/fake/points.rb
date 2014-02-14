require './fake_helpers'

POI.delete_all

100.times do
  name = Faker::Name.name
  desc = Faker::Lorem.paragraph(10)
  type = POI.types.sample.to_s
  POI.create(
    name: name,
    type: type,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    description: "<h3>#{name}</h3><span>#{type}<p>#{desc}</p>"
  )
end
