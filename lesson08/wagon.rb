require_relative 'instance_validator'

class Wagon
  include Maker
  include InstanceValidator

  WAGON_STATE = %i(hooked unhooked)

  attr_reader :number, :state, :train, :full_capacity, :occupied
 
  def initialize(number, full_capacity)
    @number = number
    @state = :unhooked
    @full_capacity = full_capacity
    @occupied = 0
    validate!
  end

  def train=(train)
    if train.nil?
      unhook
    else
      hook(train)
    end
  end

  def occupy(capacity = 1)
    return if capacity <= 0 || self.occupied + capacity > self.full_capacity

    @occupied += capacity
  end

  def free(capacity = 1)
    return if self.occupied.zero? || self.full_capacity - capacity < 0

    @occupied -= capacity
  end

  def rest
    self.full_capacity - self.occupied
  end

  protected
  
  def validate!
    raise StandardError.new("Wagon error: wagon number must not be zero") if self.number.zero?
  end

  private 

  # Эти функции используются только для данного класса, поэтому они private
  def hook(train)
    return if self.state == :hooked

    @train = train
    @state = :hooked
  end

  def unhook
    return unless self.state == :hooked

    @train = nil
    @state = :unhooked
  end
end
