require_relative 'maker'
require_relative 'instance_counter'
require_relative 'instance_validator'

class Train
  include Maker
  include InstanceCounter
  include InstanceValidator
  attr_reader :number, :route, :speed, :wagons, :error

  @@trains = {}

  def self.find(train_number)
    @@trains[train_number]
  end

  def initialize(train_number)
    initialize_train(train_number)
    register_instance
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

  def show
    puts "Номер поезда: #{self.number}, тип: #{self.type}, маршрут: "
    self.route.show unless self.route.nil?
    self.wagons.each { |wagon| puts "Вагон - #{wagon.number}".rjust(8)}
  end

  protected
  
  # Поместил в protected, т.к. должна быть возможность переопределить это значение в подклассах
  def max_speed
    60
  end

  def initialize_train(train_number)
    @number = train_number
    @wagons = []
    @speed = 0
    @current_station_index = nil
    @@trains[train_number] = self
    @error = ""
  end
  
  def validate!
    @error = ""
    if self.number.empty?
      @error = "Train error: train number must not be empty"
      raise StandardError.new(self.error)
    end
    if /[A-Fa-f0-9]{3}-?\d{2}/.match(self.number).nil?
      @error = "Train error: train number is not valid"
      raise StandardError.new(self.error)
    end
  end
end

