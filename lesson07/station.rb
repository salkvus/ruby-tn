require_relative 'instance_counter'
require_relative 'instance_validator'

class Station
  include InstanceCounter
  include InstanceValidator
  
  ERROR_DEPARTURE_METHOD = "Error in departure_train method"
  ERROR_ARRIVE_METHOD = "Error in arrive_train method"
  
  @@stations = []

  def self.all
    @@stations
  end

  attr_reader :name, :trains
  #:error

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end
  
  def arrive_train(train)
    if trains.include?(train)
      raise StationDepartureException.new(train, self, ERROR_ARRIVE_METHOD)
    end

    trains << train
  end
  
  def departure_train(train)
    unless trains.include?(train)
      raise StationDepartureException.new(train, self, ERROR_DEPARTURE_METHOD)
    end

    trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  protected
  
  def validate!
    return unless self.name.empty?
    
    raise StandardError.new("Station error: station name must not be empty")
  end
end

class StationDepartureException < StandardError
  
  def initialize(train, station, error_message)
    puts error_message
    puts "Wrong train #{train.number} for station #{station.name}"
  end
end
