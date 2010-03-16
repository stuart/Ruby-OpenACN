module ACN
  module DDL
    # Base class for devices, behaviour sets, and language sets. 
    # Called 'module' in the ACN specification.
    class DDLModule
      
      attr_accessor :ddl
      attr_reader   :uuid
      attr_accessor :provider
      attr_accessor :date
      attr_accessor :uuid_names
      attr_writer   :label
      #attr_writer   :extends
      #TODO alternatefor and extends
      
      def initialize(ddl = nil, opts = {})
        @provider = opts[:provider] || ""
        @date = opts[:date]
        @uuid_names = opts[:uuid_names] || {}
        @label = opts[:label] || {}
        @extends = opts[:extends] || {}
        @ddl = ddl
        self.uuid_or_name = opts[:uuid]
      end
      
      def label
        if @label[:text].nil?
          @ddl.translate(@label[:key], @label[:set])
        else
          @label[:text]
        end
      end
      

      def extends
       @ddl.find_module(@extends[:uuid]) if @extends[:uuid]
      end
      
      # # Replace the instance with uuid with this one.
      def alternate_for(uuid)
        @ddl.find_module(uuid)
      end
      
      # Return a valid UUID
      # Drop the leading 'U' if it is an actual UUID from the XML 
      # or get the UUID from the uuid_names hash if it is a UUIDname.
      def resolve_uuid(uuid_or_name) 
        return uuid_or_name if UUID.validate(uuid_or_name)
        if uuid_or_name.chr == 'U'
          return uuid_or_name[1..-1] 
        else
          return uuid_names[uuid_or_name.to_sym]
        end
      end
      
      # Set the uuid given a UUID or name
      # Check if the UUID is valid and set the @uuid attribute
      def uuid_or_name=(uuid_or_name)
        uuid_or_name ||= UUID.generate
        @uuid = resolve_uuid(uuid_or_name)
        raise Exception.new("UUID is not unique") unless unique_uuid?(@uuid)
        raise Exception.new("UUID is invalid") unless UUID.validate(@uuid)
      end
      
      private 
      def unique_uuid?(uuid)
        @ddl.modules.all?{|m| m.uuid != uuid || m == self}
      end
      
    end
  end
end