class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = {}
  end

  def arrive_train(train)
    type = train.type
    trains_list = trains[type] ||= []
    trains_list << train unless trains_list.include?(train)
    train.station = self
  end
  
  def departure_train(train)
    trains[train.type].delete(train)
    train.station = self
  end

  def all_trains
    trains.values.flatten(1)
  end

  def trains_by_type(type)
    trains[type]
  end

  def show_all_trains
    all_trains.each { |train| train.show }
  end

  def show_trains_by_type(type)
    trains[type].each { |train| train.show }
  end

end

class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = []
    @stations << start_station << end_station
  end

  def start_station
    stations[0] if stations.length > 0
  end

  def end_station
    stations[-1] if stations.length > 0
  end

  def add(station)
    @stations = @stations[0..-2] << station << @stations[-1]
  end

  def delete(station)
    stations.delete(station) if stations.length > 2 && station != start_station && station != end_station
  end

  def show
    stations.each { |station| puts station.name }
  end
end

class Train
  TYPES = %i[cargo passenger]
  attr_reader :number, :type, :length, :route, :speed, :TYPES
  attr_accessor :station
  
  def initialize(number, type, train_length = 0)
    raise TrainTypeException.new(type, TYPES) unless TYPES.include?(type)

    @number = number
    @type = type
    @length = train_length
    @speed = 0
    @station = nil
  end

  def show
    puts "Train num. #{self.number}, type: #{self.type}, length: #{self.length}"
  end

  def hook_carriage
    @length += 1 if speed.zero?
  end

  def unhook_carriage
    @length -= 1 if speed.zero? && length.positive?
  end

  def accelerate
    @speed += 20 if speed < 80
  end

  def stop
    @speed = 0
  end

  def route=(route)
    @route = route
    self.station = route.start_station
  end

  def go_back
    previous_station
    station.arrive_train(self)
  end

  def go_forward
    next_station
    station.arrive_train(self)
  end

  def previous_station
    self.station = route.stations[route.stations.index(station) - 1] unless station == route.start_station
  end

  def next_station
    self.station = route.stations[route.stations.index(station) + 1] unless station == route.end_station
  end
end

class TrainTypeException < StandardError
  def initialize(type, error_types)
    puts "Wrong train type '#{type}'"
    puts "Valid types #{error_types}"
  end
end
