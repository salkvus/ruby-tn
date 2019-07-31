require_relative 'Wagon'

class CargoWagon < Wagon
  attr_reader :type

  def initialize(number)
    super
    @type = :cargo
  end
end
