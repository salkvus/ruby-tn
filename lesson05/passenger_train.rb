require_relative 'Train'

class PassengerTrain < Train
  WAGON_TYPES = %i(passenger)

  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end

  def hook_wagon(wagon)
    return unless WAGON_TYPES.include?(wagon.type)
    
    super(wagon)
  end

  def unhook_wagon(wagon)
    return unless WAGON_TYPES.include?(wagon.type)
    
    super(wagon)
  end

  protected

  def max_speed
    100
  end
end
