require_relative 'train'

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive_train(train)
    raise StationDepartureException.new(train, self, "Error in arrive_train method") unless train.current_station == self

    trains << train unless trains.include?(train)
  end
  
  def departure_train(train)
    raise StationDepartureException.new(train, self, "Error in departure_train method") unless trains.include?(train)

    train.go_forward
    trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end
end

class StationDepartureException < StandardError
  def initialize(train, station, error_message)
    puts error_message
    puts "Wrong train #{train.number} for station #{station.name}"
  end
end

