require_relative 'Train'

class PassengerTrain < Train
  include InstanceCounter
  WAGON_TYPES = %i(passenger)
  
  attr_reader :type

  def initialize(train_number)
    initialize_train(train_number)
    @type = :passenger
    register_instance
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
