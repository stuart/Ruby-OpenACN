
require 'locale'

module ACN
  module DDL
    class LanguageSet < DDLModule

      attr_accessor :languages
      
      def initialize(ddl, opts = {})
        @name = opts[:name] || ""
        @languages = opts[:languages] || {}
        super(ddl,opts)
        @languages.merge!(extends.languages) if extends.is_a?(LanguageSet)
      end
      
      def translate(key,lang_code = nil)
        if lang_code.nil?
          lang_code = Locale.candidates(:type=>:simple).detect{|c| @languages.keys.include?(c.to_s.to_sym)}.to_s
        end
        
        language = @languages[LanguageSet.lang_code_to_sym(lang_code)]
        raise "No translation for language '#{lang_code}'" if language.nil?
        
        translation = language.translate(key)
        
        while !translation
          language = @languages[language.alt_lang]
          # Catch missing alt-languages here or missing translations
          if language.nil?
            raise "No translation for '#{key}' in language '#{lang_code}'"
          end
          translation = language.translate(key)
        end 
        translation
      end
      
      def add_language(language)
        @languages.merge!({language.lang_code => language})
      end
      
      # Make Locale to simple form and convert to symbol
      # A nil code will return nil.
      def self.lang_code_to_sym(code)
        unless code.nil?
          code = Locale::Tag.parse(code).to_simple.to_s
          code = code.to_sym
        end
      end
      
      # Creates a language set from Nokogiri output
      def self.from_nokogiri(ddl, doc)
        language_set = LanguageSet.new(ddl, :uuid => doc['uuid'])
        doc.xpath('.//language').each do |xml|
          language_set.add_language(Language.from_xml(xml))
        end
        return language_set
      end
    end
    
    
    class Language
      attr_accessor :lang_code
      attr_accessor :alt_lang
      attr_accessor :strings
      
      def initialize
        @strings = {}
      end
      
      def translate(key)
        @strings[key]
      end
      
      def add_string(key, string)
        @strings[key] = string
      end
      
      def self.from_xml(doc)
        lang = Language.new()
        lang.lang_code = LanguageSet.lang_code_to_sym(doc['lang'])
        lang.alt_lang = LanguageSet.lang_code_to_sym(doc['altlang'])
        doc.xpath('.//string').each do |s|
          lang.strings.merge!(s['key'] => s.content)
        end
        return lang
      end
    end
    
  end
  
end