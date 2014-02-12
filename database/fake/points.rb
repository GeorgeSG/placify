require './fake_helpers'

POI.delete_all

types = ['pharmacy', 'restaurant', 'hotel', 'billiard', 'snooker', 'casino', 'supermarket', 'cinema', 'bookstore', 'mall']


100.times do
  name = Faker::Name.name
  desc = Faker::Lorem.paragraph(10)
  type = types.sample
  POI.create(
    name: name,
    type: type,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    description: "<h3>#{name}</h3><span>#{type}<p>#{desc}</p>"
  )
end
