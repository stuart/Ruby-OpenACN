require 'nokogiri'
require 'open-uri'
require 'uuid'

require File.expand_path(File.dirname(__FILE__) + '/DDL_module.rb')
require File.expand_path(File.dirname(__FILE__) + '/DDL_element.rb')
require File.expand_path(File.dirname(__FILE__) + '/device_description.rb')
require File.expand_path(File.dirname(__FILE__) + '/language_set.rb')
require File.expand_path(File.dirname(__FILE__) + '/behavior_set.rb')

module ACN
  module DDL
    # Architecture for Control Networks
    # Device Description Language Interface
    #
    # The DDL class encapsulates the data for DDL Modules.
    # Modules consist of devices,languagesets and behavioursets
    # It can combine the root elements of several DDL files
    #
    # Loading a DDL file flattens the layering or nesting of included DDL elements.
    # The ACN specification states that "Nesting of DDL elements contains no meaning."
    # 
    class DDL
    
      # The currently supported version of DDL
      SupportedVersion = "1.0" 
    
      # The DDL file version used to create this DDL
      # Cannot be > Supported Version
      attr_reader :version
    
      # The array of device descriptions
      attr_accessor :devices
    
      # The array of behaviours
      attr_accessor :behavior_sets
    
      # The array of language sets
      attr_accessor :language_sets
      
      # An array of errors from the Nokogiri parser
      attr_accessor :errors
      
      def initialize(v = SupportedVersion)
        @version = v
        @devices = []
        @language_sets = []
        @behavior_sets = []
        @errors = []
      end
      
      def version=(new_version)
        if new_version.to_s > SupportedVersion
          raise "Cannot support this DDL version. Current version is #{SupportedVersion}."
        else
          @version = new_version.to_s
        end
      end
      
      # Create a new DDL object form a file or io
      def self.from_xml(xml)
        doc = Nokogiri::XML::Document.parse(xml)
        ddl = DDL.new(doc.root["version"])
        ddl.add_elements(doc)
        return ddl
      end
    
      # Read new Modules in from an IO or string object via Nokogiri
      # xml can be any io or XML string or URI
      def read(xml)
        add_elements(Nokogiri::XML.parse(xml))
      end
    
      # Write this DDL to an IO
      def write(xml)
      end

      # Add elements to the DDL
      def add_elements(doc)
        @errors += doc.errors
        
        doc.xpath('.//device').each do |xml|
          @devices << DeviceDescription.from_nokogiri(self, xml)
        end

        doc.xpath('.//languageset').each do |xml|
          @language_sets << LanguageSet.from_nokogiri(self, xml)
        end

        doc.xpath('.//behaviorset').each do |xml|
          @behavior_sets << BehaviorSet.from_nokogiri(self, xml)
        end
      end
      
      def modules
        @devices + @behavior_sets + @language_sets
      end
      
      def get_module(uuid)
        modules.find{|m| m.uuid == uuid}
      end
      
      def add_device_description(opts = {})
        devices << DeviceDescription.new(self,opts)
      end
      
      def add_behavior_set(opts ={})
        behavior_sets << BehaviorSet.new(self,opts)
      end
      
      def add_language_set(opts ={})
         language_sets << LanguageSet.new(self,opts)
       end
      
      def get_device_description(uuid)
        devices.find{|d| d.uuid == uuid}
      end
      
      def get_behavior_set(uuid)
        behavior_sets.find{|d| d.uuid == uuid}
      end
      
      def get_language_set(uuid)
        language_sets.find{|d| d.uuid == uuid}
      end
      
      def get_language(uuid, locale = Locale.current)
        get_language_set(uuid).languages[locale]
      end
      
      def translate(key,lang,uuid)
        langset = get_language_set(uuid)
        langset.translate(key,lang)
      end
      
    end
    
  end
end