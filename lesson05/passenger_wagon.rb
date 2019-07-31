require_relative 'Wagon'

class PassengerWagon < Wagon
  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end
end

