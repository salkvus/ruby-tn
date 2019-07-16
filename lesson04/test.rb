require_relative 'station'

st1 = Station.new('Moscow')
st2 = Station.new('Saint-Petersburg')
st3 = Station.new('Pskov')
st4 = Station.new('Kiev')

rt1 = Route.new(st1, st4)
puts "start_station: #{rt1.start_station.name}"
puts "end_station: #{rt1.end_station.name}"
puts "\"Adding #{st2.name} #{st3.name}\""
rt1.add(st2)
rt1.add(st3)
rt1.show
puts "\"Deleting #{st3.name}\""
rt1.delete(st3)
rt1.show

tr1 = Train.new("11", :passenger, 10)
puts "Assigning route"
tr1.route = rt1
puts "Train station: #{tr1.station.name}"
puts "Hooking 2 carriages"
tr1.hook_carriage
tr1.hook_carriage
puts "Train length: #{tr1.length}"
puts "Unhooking 1 carriage"
tr1.unhook_carriage()
puts "Train length: #{tr1.length}"
puts "Train speed: #{tr1.speed}"
puts "Accelerating train ..."
tr1.accelerate
puts "Train speed: #{tr1.speed}"
tr1.accelerate
puts "Train speed: #{tr1.speed}"
puts "Go forward ..."
tr1.go_forward
puts "Train station: #{tr1.station.name}"
puts "Go forward ..."
tr1.go_forward
puts "Train station: #{tr1.station.name}"
puts "Go back ..."
tr1.go_back

tr2 = Train.new("22", :cargo, 20)
rt2 = Route.new(st1, st3)
puts "Assigning route for train #{tr2.number}"
tr2.route = rt2
rt2.show
puts "Adding station #{st2.name} to #{tr2.number} train:"
rt2.add(st2)
rt2.show
st2.arrive_train(tr2)

puts "Get all trains:"
puts st2.all_trains
puts "Get trains by type:"
puts st2.trains_by_type(:passenger)

puts "Train #{tr1.number} station: #{ tr1.station.name}"
puts "Train #{tr2.number} station: #{ tr2.station.name}"
puts "Show trains #{:cargo} type on station #{st2.name}:"
st2.show_trains_by_type(:cargo)
puts "Show all trains on station #{st2.name}:"
st2.show_all_trains

puts "Train #{tr1.number} route:"
tr1.route.show
puts "Train #{tr2.number} route:"
tr2.route.show
puts "Train #{tr2.number} departure from #{st2.name} to #{st3.name}:"
st2.departure_train(tr2, st3)

puts "Train #{tr2.number} now on #{tr2.station.name}"
