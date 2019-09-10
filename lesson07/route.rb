require_relative 'instance_counter'
require_relative 'instance_validator'

class Route
  include InstanceCounter
  include InstanceValidator

  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    validate!
    register_instance
  end

  def start_station
    stations.first
  end

  def end_station
    stations.last
  end

  def add(station)
    return @stations.insert(-2, station) if @stations.length >= 2

    @stations << station
  end

  def delete(station)
    return if [start_station, end_station].include?(station)

    stations.delete(station)
  end

  def show
    stations.each.with_index { |station, index| puts (index + 1).to_s.rjust(4) + " - " + station.name }
  end

  protected
  
  def validate!
    raise StandardError.new("Route error: start station must not be empty") if self.start_station.nil?
    raise StandardError.new("Route error: end station must not be empty") if self.end_station.nil?
    raise StandardError.new("Route error: start station and end station must not be the same") if self.start_station == self.end_station
  end
end
