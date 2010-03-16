require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
include ACN::DDL

describe "Language Set :" do
  
  before do
    @ddl = mock(DDL, :modules => [])
  end
  
    before do
     @ddl_file = File.open(File.expand_path(File.dirname(__FILE__) + '/support/ddl_test.xml'))
     doc = Nokogiri.parse(@ddl_file)
     xml = doc.xpath("//languageset").first
     @lang_set = LanguageSet.from_nokogiri(@ddl,xml)
    end
    
    it "en-gb have 2 strings" do
      @lang_set.languages[:en_GB].should have(2).strings
    end
    
    it "en-us should have 1 string" do
      @lang_set.languages[:en_US].should have(1).strings
    end
    
    it "en_us should have en-gb as alt languguage" do
      @lang_set.languages[:en_US].alt_lang.should == :en_GB
    end
    
    it "should translate color and colour" do
      @lang_set.translate('colr', :en_GB).should == "colour"
      @lang_set.translate('colr', :en_US).should == "color"
    end
    
    it "should translate red using the alt-lang attribute" do
      @lang_set.translate('red', :en_GB).should == "red"
      @lang_set.translate('red', :en_US).should == "red"
    end
    
    it "should translate blue using the alt-lang attribute twice" do
      @lang_set.translate('blue', :en_US).should == "blue"
    end
    
    it "should use the current locale to find a string if none is given" do
      Locale.current = "en_US"
      @lang_set.translate('colr').should == "color"
      Locale.current = "en_GB"
      @lang_set.translate('colr').should == "colour"
    end
    
    it "should search the system locale candidates for a match" do
      Locale.current = "en_AU"
      @lang_set.translate('colr').should == "colour"
      @lang_set.translate('red').should == "red"
      
    end
    
    it "should deal with locales with encodings" do
      Locale.current ="en_US.UTF8"
      @lang_set.translate('colr').should == "color"
    end
    
    describe "Handling missing translations" do
      it "should raise an error if an appropriate language is missing" do
        lambda do
          @lang_set.translate('colr',"fr_CA")
        end.should raise_error("No translation for language 'fr_CA'")      
      end
      
      it "should raise an error if a translation is missing" do
        lambda do
          @lang_set.translate('yellow',"en_GB")
        end.should raise_error("No translation for 'yellow' in language 'en_GB'")
      end
    end
    
    
    describe "extending Language Sets" do
      it "should extend the language set" do
        @ddl.stub(:find_module).with(@lang_set.uuid).and_return(@lang_set)
        @extending_lang_set = LanguageSet.new(@ddl, {:extends => {:uuid => @lang_set.uuid}})
        @extending_lang_set.extends.should == @lang_set
      end
      
      it "should include the translations from the extended language set" do
        @ddl.stub(:find_module).with(@lang_set.uuid).and_return(@lang_set)
        @extending_lang_set = LanguageSet.new(@ddl, {:extends => {:uuid => @lang_set.uuid}})
        @extending_lang_set.translate('red').should == "red"
      end

  end
end