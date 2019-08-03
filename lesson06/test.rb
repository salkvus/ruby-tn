require_relative 'train'
require_relative 'route'
require_relative 'station'

train1 = Train.new("aa_01")
puts "Train instances #{Train::ClassMethods.instances}"
train2 = Train.new("bb_02")
puts "Train instances #{Train::ClassMethods.instances}"

station1 = Station.new("Moscow")
puts "Station instances #{Station::ClassMethods.instances}"
station2 = Station.new("Kiev")
puts "Station instances #{Station::ClassMethods.instances}"
route = Route.new(station1, station2)
puts "Route instances #{Route::ClassMethods.instances}"
