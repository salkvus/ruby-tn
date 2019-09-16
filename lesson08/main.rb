require_relative 'railroad'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

railroad = Railroad.new
railroad.create_station("Moscow")
railroad.create_station("Kiev")
railroad.create_station("Pskov")

stations = railroad.stations

railroad.create_route(stations[0], stations[1])
railroad.create_route(stations[0], stations[2])

railroad.create_train(PassengerTrain, "sss-a1a")
pass_train = railroad.trains[0]
pass_train.route = railroad.routes[0]
pass_train.hook_wagon(PassengerWagon.new(1, 48))
pass_train.hook_wagon(PassengerWagon.new(2, 48))

railroad.create_train(CargoTrain, "ttt-b2b")
cargo_train = railroad.trains[1]
cargo_train.route = railroad.routes[1]
cargo_train.hook_wagon(CargoWagon.new(1, 120))
cargo_train.hook_wagon(CargoWagon.new(1, 160))
cargo_train.hook_wagon(CargoWagon.new(3, 140))

stations.each do |station|
  station.process_trains do |train| 
    puts "Номер поезда: #{train.number}, тип: #{train.type}, кол.вагонов: #{train.wagons.length}"
    train.process_wagons do |wagon|
      if wagon.type == :cargo
        str1 = "свободный объем"
        str2 = "занятый объем"
      else
        str1 = "кол. свободных мест"
        str2 = "кол.занятых мест"
      end
      puts "  Вагон: #{wagon.number}, тип: #{wagon.type}, #{str1}: #{wagon.full_capacity - wagon.occupied}, #{str2}: #{wagon.occupied}"
    end
  end
end
