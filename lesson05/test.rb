require_relative 'station'
require_relative 'route'
require_relative 'train_pass'
require_relative 'train_cargo'
require_relative 'wagon_pass'
require_relative 'wagon_cargo'

#Show methods
def Station.show_all_trains(station)
  station.trains.each { |train| Train.show(train) }
end

def Station.show_trains_by_type(station, type)
  station.trains_by_type(type).each { |train| Train.show(train) }
end

def Train.show(train)
  puts "Train num. #{train.number}, type: #{train.type}, length: #{train.wagons_count}"
end

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
puts

tr1 = PassengerTrain.new("11")
puts "Assigning route for train #{tr1.number}"
tr1.route = rt1
puts "Train station: #{tr1.current_station.name}"

puts "Hooking 3 carriages"
wg1 = PassengerWagon.new("1")
wg2 = PassengerWagon.new("2")
wg3 = PassengerWagon.new("3")
tr1.hook_wagon(wg1)
tr1.hook_wagon(wg2)
tr1.hook_wagon(wg3)
puts "Train length: #{tr1.wagons_count}"
puts "Unhooking 1 carriage"
tr1.unhook_wagon(wg3)
puts "Train length: #{tr1.wagons_count}"

puts "Train speed: #{tr1.speed}"
puts "Accelerating train ..."
tr1.accelerate(20)
puts "Train #{tr1.number} speed: #{tr1.speed}"
tr1.accelerate(30)
puts "Train #{tr1.number} speed: #{tr1.speed}"
puts "Go forward ..."
tr1.go_forward
puts "Train #{tr1.number} got station: #{tr1.current_station.name}"
puts "Go forward ..."
tr1.go_forward
puts "Train #{tr1.number} got station: #{tr1.current_station.name}"
puts "Go back ..."
tr1.go_back
puts "Train #{tr1.number} got station: #{tr1.current_station.name}"
puts

tr2 = CargoTrain.new("22")
rt2 = Route.new(st1, st3)
puts "Assigning route for train #{tr2.number}"
tr2.route = rt2
rt2.show
puts

puts "Adding station #{st2.name} to #{tr2.number} train:"
rt2.add(st2)
rt2.show
puts

#st2.arrive_train(tr2)
puts "Train #{tr2.number} got station: #{tr2.current_station.name}"
puts

puts "Get all trains for station #{st2.name}"
puts st2.trains
puts "Get trains by type for station #{st2.name}:"
puts st2.trains_by_type(:passenger)
puts

puts "Train #{tr1.number} station: #{ tr1.current_station.name}"
puts "Train #{tr2.number} station: #{ tr2.current_station.name}"
puts "Show all trains on station #{st2.name}:"
Station.show_all_trains(st2)
puts "Show trains #{:cargo} type on station #{st1.name}:"
Station.show_trains_by_type(st1, :cargo)
puts

puts "Train #{tr1.number} route:"
tr1.route.show
puts "Train #{tr2.number} route:"
tr2.route.show
puts

puts "Train #{tr2.number} before departure station: #{tr2.current_station.name}"
puts "Train #{tr2.number} departure from #{tr2.current_station.name} to #{tr2.next_station.name}"
tr2.current_station.departure_train(tr2)

puts "Train #{tr2.number} now on #{tr2.current_station.name} station"
