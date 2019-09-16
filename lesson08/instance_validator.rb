module InstanceValidator
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def valid?
      self.validate!
      true
    rescue
      false
    end
  end
end
