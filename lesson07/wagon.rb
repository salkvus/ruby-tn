require_relative 'instance_validator'

class Wagon
  include Maker
  include InstanceValidator

  WAGON_STATE = %i(hooked unhooked)

  attr_reader :number, :state, :train, :error
 
  def initialize(number)
    @number = number
    @state = :unhooked
  end

  def train=(train)
    if train.nil?
      unhook
    else
      hook(train)
    end
  end

  protected
  
  def validate!
    @error = ""
    if self.number.zero?
      @error = "Wagon error: wagon number must not be zero"
      raise StandardError.new(self.error)
    end
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
