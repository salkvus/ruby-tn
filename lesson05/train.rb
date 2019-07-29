class Train
  attr_reader :number, :route, :speed, :wagons
  
  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @current_station_index = nil
  end

  def hook_wagon(wagon)
    return unless speed.zero? && !wagons.include?(wagon)

    wagons << wagon
    wagon.train = self
  end

  def unhook_wagon(wagon)
    return unless speed.zero? && wagons.include?(wagon)

    wagon.train = nil
    wagons.delete(wagon)
  end

  def unhook_wagon_by_number(number)
    return unless speed.zero?

    wagon = wagons.select { |wagon| wagon.number == number }.pop
    return puts "Не найден вагон с номером  #{number}" if wagon.nil?
    
    wagon.train = nil
    wagons.delete(wagon)
  end

  def accelerate(speed_increment)
    return if speed + speed_increment > max_speed

    @speed += speed_increment
    @speed = 0 if speed.negative?
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

    @current_station_index = route.stations.index(current_station)
    current_station.departure_train(self)
    previous_station.arrive_train(self)
    @current_station_index -= 1
  end

  def go_forward
    return unless next_station
    
    @current_station_index = route.stations.index(current_station)
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

  protected
  
  # Поместил в protected, т.к. должна быть возможность переопределить это значение в подклассах
  def max_speed
    60
  end
end

