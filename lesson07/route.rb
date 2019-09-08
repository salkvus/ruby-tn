require_relative 'instance_counter'
require_relative 'instance_validator'

class Route
  include InstanceCounter
  include InstanceValidator

  attr_reader :stations, :error

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    @error = ""
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
    @error = ""
    if self.start_station.nil?
      @error = "Route error: start station must not be empty"
      raise StandardError.new(self.error)
    end
    if self.end_station.nil?
      @error = "Route error: end station must not be empty"
      raise StandardError.new(self.error)
    end
    if self.start_station == self.end_station
      @error = "Route error: start station and end station must not be the same"
      raise StandardError.new(self.error)
    end
  end
end
