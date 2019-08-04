require_relative 'train'
require_relative 'passenger_train'
require_relative 'route'
require_relative 'station'

train1 = Train.new("aa_01")
puts "Train instances #{Train.instances}"
train2 = Train.new("bb_02")
puts "Train instances #{Train.instances}"

pass_train1 = PassengerTrain.new("pa_02")
puts "Pass.train instances #{PassengerTrain.instances}"

pass_train2 = PassengerTrain.new("pb_02")
puts "Pass.train instances #{PassengerTrain.instances}"

station1 = Station.new("Moscow")
puts "Station instances #{Station.instances}"
station2 = Station.new("Kiev")
puts "Station instances #{Station.instances}"

route = Route.new(station1, station2)
puts "Route instances #{Route.instances}"
