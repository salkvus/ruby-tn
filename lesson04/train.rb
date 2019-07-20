require_relative 'station'
require_relative 'route'

class Train
  TYPES = %i[cargo passenger]
  MAX_SPEED = 80
  attr_reader :number, :type, :carriages_count, :route, :speed
  
  def initialize(number, type, carriages_count = 0)
    raise TrainTypeException.new(type, TYPES) unless TYPES.include?(type)

    @number = number
    @type = type
    @carriages_count = carriages_count
    @speed = 0
    @current_station_index = nil
  end

  def hook_carriage
    @carriages_count += 1 if speed.zero?
  end

  def unhook_carriage
    @carriages_count -= 1 if speed.zero? && carriages_count.positive?
  end

  def accelerate(inc_speed)
    @speed += inc_speed if speed + inc_speed <= MAX_SPEED
  end

  def stop
    @speed = 0
  end

  def route=(route)
    @route = route
    @current_station_index = 0
    current_station.arrive_train(self)
  end

  def go_back
    @current_station_index = route.stations.index(previous_station)
    current_station.arrive_train(self)
  end

  def go_forward
    @current_station_index = route.stations.index(next_station)
    current_station.arrive_train(self)
  end

  def current_station
    return unless route
    route.stations[@current_station_index]
  end

  def previous_station
    return unless route
    route.stations[@current_station_index - 1] unless current_station == route.start_station
  end

  def next_station
    return unless route
    route.stations[@current_station_index + 1] unless current_station == route.end_station
  end
end

class TrainTypeException < StandardError
  def initialize(type, error_types)
    puts "Wrong train type '#{type}'"
    puts "Valid types #{error_types}"
  end
end
