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
    station = Station.new(name)
    raise StandardError.new(station.error) unless station.valid?

    @stations << station
    puts "Создана станция \"#{station.name}\""
  end

  def create_route(start_station, end_station)
    route = Route.new(start_station, end_station)
    raise StandardError.new(route.error) unless route.valid?

    @routes << route
    if route.valid?
      puts "Создан маршрут: "
      route.show
    end
    puts
  end

  def create_train(train_class, train_number)
    raise StandardError.new("Create train error: invalid train class") if train_class.nil?
    train = train_class.new(train_number)
    raise StandardError.new(train.error) unless train.valid?

    @trains << train
    puts "Создан поезд: "
    train.show
  end

  def add_station_to_route(route, station)
    raise StandardError.new("Adding station for route error: station #{station.name} was also included") if route.stations.include?(station)
  
    route.add(station)
  end

  def delete_station_from_route(route, station)
    raise StandardError.new("Deleting station from route error: station #{station.name} is not included in route") unless route.stations.include?(station)
  
    route.stations.delete(station)
  end

  def assign_route_to_train(route, train)
    train.route = route
  end

  def hook_train_wagon(train, wagon_number)
    wagon = train.wagons.select { |wagon| wagon.number == wagon_number}.pop
    unless wagon.nil?
      puts "Уже есть вагон с номером #{wagon.number}".rjust(4)
      return
    end

    if train.type == :passenger
      wagon = PassengerWagon.new(wagon_number)
      raise StandardError.new(wagon.error) unless wagon.valid?
    else
      wagon = CargoWagon.new(wagon_number)
      raise StandardError.new(wagon.error) unless wagon.valid?
    end
    train.hook_wagon(wagon) unless wagon.nil?
  end

  def unhook_train_wagon(train, wagon_number)
    wagon = train.wagons.select { |wagon| wagon.number == wagon_number }.pop
    if wagon.nil?
      puts "Не найден вагон с номером  #{wagon_number}"
      return
    end

    train.unhook_wagon(wagon)
  end
end
