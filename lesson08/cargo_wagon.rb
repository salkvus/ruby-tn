require_relative 'Wagon'

class CargoWagon < Wagon
  include InstanceValidator

  attr_reader :type

  def initialize(number, full_capacity)
    @type = :cargo
    super
    validate!
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

