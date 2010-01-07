module ACN
  module DDL
    class UUID
      
      NAME_REGEXP = /^([^U][a-zA-TV-Z\._0-9])([a-zA-Z\._0-9]{1,32})$/
      UUID_REGEXP = /^U([0-9a-fA-F]{8})-([0-9a-fA-F]{4})-([0-9a-fA-F]{4})-([0-9a-fA-F]{2})([0-9a-fA-F]{2})-([0-9a-fA-F]{12})$/
      
      def self.valid?(string)
        !NAME_REGEXP.match(string).nil? || !UUID_REGEXP.match(string).nil?
      end
      
      def self.name?(string)
        !NAME_REGEXP.match(string).nil?
      end
      
      def self.uuid?(string)
        !UUID_REGEXP.match(string).nil?
      end
      
      def self.uuid
        return 
      end
      
    end
  end
end