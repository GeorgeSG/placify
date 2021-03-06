require './fake_helpers'

UserPoi.delete_all

types = ['pharmacy', 'restaurant', 'hotel', 'billiard', 'snooker', 'casino', 'supermarket', 'cinema', 'bookstore', 'mall']

100.times do
  user = User.all.sample
  name = Faker::Name.name
  desc = Faker::Lorem.paragraph(10)
  type = types.sample

  poi = UserPoi.new(
    name: name,
    type: type,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    description: "<h3>#{name}</h3><span>#{type}<p>#{desc}</p>"
  )

  poi.user = user
  poi.save
end
