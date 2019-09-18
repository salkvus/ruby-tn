require_relative 'Wagon'

class PassengerWagon < Wagon
  include InstanceValidator

  attr_reader :type

  def initialize(number, full_capacity)
    @type = :passenger
    super
    validate!
  end

  def occupy
    super(1)
  end

  def free
    super(1)
  end

  def str
    "Вагон: #{self.number}, тип: #{self.type}, кол. свободных мест: #{self.full_capacity - self.occupied}, кол.занятых мест: #{self.occupied}"
  end

  protected

  def validate!
    super
    raise StandardError.new("Passenger wagon error: number of seats must be more than zero") if self.full_capacity.zero?
  end
end
