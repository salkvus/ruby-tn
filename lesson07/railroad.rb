require_relative 'passenger_train'
require_relative 'cargo_train'

class Railroad
  TRAIN_TYPES = [PassengerTrain, CargoTrain]
  attr_accessor :stations, :trains, :routes, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def create_station(name)
    @stations << Station.new(name)
    puts "Создана станция \"#{self.stations[-1].name}\""
  end

  def create_route(start_station, end_station)
    @routes << Route.new(start_station, end_station)
    puts "Создан маршрут: "
    self.routes[-1].show
  end

  def create_train(train_class, train_number)
    raise ArgumentError.new("Create train error: train class is nil") if train_class.nil?
    @trains << train_class.new(train_number)
    puts "Создан поезд: "
    trains[-1].show
  end

  def add_station_to_route(route, station)
    raise ArgumentError.new("Adding station for route error: route is nil") if route.nil?
    raise ArgumentError.new("Adding station for route error: station #{station.name} was also included") if route.stations.include?(station)
    route.add(station)
  end

  def delete_station_from_route(route, station)
    raise ArgumentError.new("Deleting station from route error: station #{station.name} is not included in route") unless route.stations.include?(station)
    route.stations.delete(station)
  end

  def assign_route_to_train(route, train)
    train.route = route
  end

  def hook_train_wagon(train, wagon_number)
    wagon = train.wagons.select { |wagon| wagon.number == wagon_number}.pop
    raise StandardError.new("Уже есть вагон с номером #{wagon.number}") if wagon.nil?
    wagon = PassengerWagon.new(wagon_number) if train.type == :passenger
    wagon = CargoWagon.new(wagon_number) if train.type == :cargo
    train.hook_wagon(wagon)
  end

  def unhook_train_wagon(train, wagon_number)
    wagon = train.wagons.select { |wagon| wagon.number == wagon_number }.pop
    raise StandardError.new("Не найден вагон с номером  #{wagon_number}") if wagon.nil?
    train.unhook_wagon(wagon)
  end
end
