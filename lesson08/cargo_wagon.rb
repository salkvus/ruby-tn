require_relative 'Wagon'

class CargoWagon < Wagon
  include InstanceValidator

  attr_reader :type, :full_capacity, :occupied

  def initialize(number, full_capacity)
    @type = :cargo
    @full_capacity = full_capacity
    @occupied = 0
    super(number)
    validate!
  end

  def occupy(capacity)
    return if capacity <= 0 || self.occupied + capacity > self.full_capacity

    @occupied += capacity
  end

  def free(capacity)
    return if self.occupied.zero? || self.full_capacity - capacity < 0

    @occupied -= capacity
  end

  def rest
    self.full_capacity - self.occupied
  end

  def str
    "Вагон: #{self.number}, тип: #{self.type}, свободный объем: #{self.full_capacity - self.occupied}, занятый объем: #{self.occupied}"
  end

  protected

  def validate!
    super
    raise StandardError.new("Cargo wagon error: full wagon volume must be more than zero") if self.full_capacity.zero?
  end
end

