require './fake_helpers'

Poi.delete_all

beginnings = [0, 600, 800, 900, 1000, 1200]
endings = [1800, 1900, 2000, 2100]


100.times do
  name = Faker::Name.name
  desc = Faker::Lorem.paragraph(10)
  type = Poi.types.sample.to_s
  Poi.create(
    name: name,
    type: type,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    description: desc,
    schedule: {mon: [beginnings.sample, endings.sample],
               tue: [beginnings.sample, endings.sample],
               wed: [beginnings.sample, endings.sample],
               thu: [beginnings.sample, endings.sample],
               fri: [beginnings.sample, endings.sample]}
  )
end
