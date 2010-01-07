module ACN
  module DDL
    # TODO Deprecate.
    # Base class for elements within DDL modules that have UUID's
    class DDLElement
      attr_accessor :module
      
      attr_accessor :uuid
      
      def initialize(mod, opts = {})
        @module = mod
        self.uuid_or_name = opts[:uuid]
      end
      
      def uuid_or_name=(uuid_or_name)
        uuid_or_name ||= UUID.generate
        @uuid = @module.resolve_uuid(uuid_or_name)
      end
      
    end
  end
end 