require_relative 'Wagon'

class PassengerWagon < Wagon
  include InstanceValidator

  attr_reader :type, :full_capacity, :occupied

  def initialize(number, full_capacity)
    @type = :passenger
    @full_capacity = full_capacity
    @occupied = 0
    super(number)
    validate!
  end

  def occupy
    return unless self.occupied < self.full_capacity

    @occupied += 1
  end

  def free
    return unless self.occupied.zero?

    @occupied -= 1
  end

  def rest
    self.full_capacity - self.occupied
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
