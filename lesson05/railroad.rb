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
    return if name.empty?

    @stations << Station.new(name)
  end

  def create_route(start_station, end_station)
    @routes << Route.new(start_station, end_station)
  end

  def create_train(train_class, number)
    @trains << train_class.new(number)
  end

  def add_station_to_route(route, station)
    return if route.stations.include?(station)

    route.add(station)
  end

  def delete_station_from_route(route, station)
    return unless route.stations.include?(station)

    route.stations.delete(station)
  end

  def assign_route_to_train(route, train)
    return if train.nil?

    train.route = route
  end
end
