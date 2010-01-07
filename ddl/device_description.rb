module ACN
  module DDL
    class DeviceDescription < DDLModule
      
      attr_accessor :properties
      attr_accessor :parameters
      attr_accessor :included_devices
      attr_accessor :parent # Parent device if this is included.
      
      def initialize(ddl,opts = {})
        @properties = opts[:properties]
        @parameters = opts[:parameters]
        
        super
      end
      
      def from_nokogiri(ddl,xml)
        # TODO set up properties/params/included devs
        DeviceDescription.new(ddl)
      end
    end
  end
end
