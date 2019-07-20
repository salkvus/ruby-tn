require_relative 'station'

class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def start_station
    stations.first
  end

  def end_station
    stations.last
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def delete(station)
    return if [start_station, end_station].include?(station)
    stations.delete(station)
  end

  def show
    stations.each { |station| puts station.name }
  end
end
