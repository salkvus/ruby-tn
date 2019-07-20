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

  def accelerate(speed_increment)
    return if speed + speed_increment > MAX_SPEED
    @speed += speed_increment
    @speed = 0 if speed < 0
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
    return unless previous_station
    current_station.departure_train(self)
    previous_station.arrive_train(self)
    @current_station_index -= 1
  end

  def go_forward
    return unless next_station
    current_station.departure_train(self)
    next_station.arrive_train(self)
    @current_station_index += 1
  end

  def current_station
    route.stations[@current_station_index]
  end

  def previous_station
    return unless @current_station_index.positive?
    route.stations[@current_station_index - 1]
  end

  def next_station
    route.stations[@current_station_index + 1]
  end
end

class TrainTypeException < StandardError
  def initialize(type, error_types)
    puts "Wrong train type '#{type}'"
    puts "Valid types #{error_types}"
  end
end
