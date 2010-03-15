module ACN
  module DDL
    class DeviceDescription < DDLModule
      
      attr_accessor :properties
      attr_accessor :parameters
      attr_accessor :included_devices
      attr_accessor :parent # Parent device if this is included.
      
      def initialize(ddl,opts = {})
        @properties = opts[:properties] || {}
        @parameters = opts[:parameters] || {}
        @included_devices = opts[:included_devices] || {}
        @parent = opts[:parent] || nil
        super
      end
      
      def from_nokogiri(ddl,xml)
        # TODO set up properties/params/included devs/parent
        DeviceDescription.new(ddl)
      end
      
      def parent=(new_parent)
        raise ArgumentError if (new_parent == self)
        @parent = new_parent
      end
      
    end
    
    
    class Property
    
    end
    
    class Parameter
    
    end
    
  end
end
