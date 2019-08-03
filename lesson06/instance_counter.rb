module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    @instances = 0
    class << self
      attr_accessor :instances
    end
  end

  module InstanceMethods

    def register_instance
      ClassMethods.instances += 1
    end
  end
end
