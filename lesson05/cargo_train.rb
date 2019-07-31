require_relative 'Train'

class CargoTrain < Train
  WAGON_TYPES = %i(cargo)

  attr_reader :type

  def initialize(number)
    super
    @type = :cargo
  end

  def hook_wagon(wagon)
    return unless WAGON_TYPES.include?(wagon.type)
    
    super
  end

  def unhook_wagon(wagon)
    return unless WAGON_TYPES.include?(wagon.type)
    
    super(wagon)
  end

  protected

  def max_speed
    80
  end
end
