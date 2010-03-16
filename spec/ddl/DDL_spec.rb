require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
include ACN::DDL

describe "DDL : " do
  before do
    @ddl = DDL.new
    @ddl_file = File.open(File.expand_path(File.dirname(__FILE__) + '/support/ddl_test.xml'))
    DeviceDescription.stub!(:from_nokogiri).and_return(@mock_device = mock(DeviceDescription))
    LanguageSet.stub(:from_nokogiri).and_return(@mock_language = mock(LanguageSet))
    BehaviorSet.stub!(:from_nokogiri).and_return(@mock_behaviour = mock(BehaviorSet))
  end
  
  describe "version" do
    it "supported version should be 1.0" do
      DDL::SupportedVersion.should == "1.0"
    end
    
    it "should have a version number" do
      @ddl.version.should == "1.0"
    end
    
    it "should be able to set version number to < SupportedVersion" do
      @ddl.version = "0.9"
      @ddl.version.should == "0.9"
    end
    
    it "should raise an error if we try to set version too high" do
      lambda{
        @ddl.version = "1.1"}.should raise_error
    end
    
    it "should take the version as a float" do
      lambda{
         @ddl.version = 1.0 }.should_not raise_error
      @ddl.version.should == "1.0"
    end
    
  end
  
  
  describe "from IO" do
    
    it "loading a file should create a new DDL object" do
      @ddl = DDL.from_xml(@ddl_file)
      @ddl.instance_of?(DDL).should be_true
    end
    
    it "loading should set the version" do
      @ddl = DDL.from_xml(@ddl_file)
      @ddl.version.should == "1.0"
    end
    
    it "should create 3 devices" do
      @ddl = DDL.from_xml(@ddl_file)
      @ddl.devices.should == [@mock_device, @mock_device, @mock_device]
    end
    
    it "should contain a language set" do
      @ddl = DDL.from_xml(@ddl_file)
      @ddl.language_sets.should == [@mock_language]
    end
    
    it "should contain a behaviour set" do
      @ddl = DDL.from_xml(@ddl_file)
      @ddl.behavior_sets.should == [@mock_behaviour]
    end
    
  end
  
  describe "adding more ddl data" do
    before do

      @ddl = DDL.from_xml(@ddl_file)
    end
    
    it do
      @ddl.read("<DDL><device></device><device></device></DDL>")
      @ddl.should have(5).devices
    end
    it do
      @ddl.read("<DDL><languageset</languageset></DDL>")
      @ddl.should have(2).language_sets
    end
    
    it do
      @ddl.read("<DDL><behaviorset</behaviorset></DDL>")
      @ddl.should have(2).behavior_sets
    end
  end
  
  describe "checking for errors" do
    
    it "should keep the Nokogiri errors" do
       @ddl = DDL.from_xml("<DDL><device></DDL>")
       @ddl.should have(2).errors
       puts @ddl.errors
    end
    
    it "should have no errors when loading the test ddl" do
       @ddl = DDL.from_xml(@ddl_file)
       @ddl.should have(0).errors
    end
  end
  
  describe "returning all modules" do
    it "should return all modules" do
      @ddl =  DDL.from_xml(@ddl_file)
      @ddl.modules.should == [@mock_device, @mock_device, @mock_device,@mock_behaviour,@mock_language]
    end
  end
  
  describe "finding a module by UUID (get_module, get_device etc...)" do
    it "should return the correct device" do
      @mock_device.should_receive(:uuid).and_return(UUID_1)
      @ddl = DDL.from_xml(@ddl_file)
      @ddl.get_module(UUID_1).should == @mock_device
    end
    
    it "should find a device given the right uuid" do
        @mock_device.should_receive(:uuid).and_return(UUID_2)
        @ddl = DDL.from_xml(@ddl_file)
        @ddl.get_device_description(UUID_2).should == @mock_device
    end
    
    it "should find a language_set given the right uuid" do
        @mock_language.should_receive(:uuid).and_return(UUID_3)
        @ddl = DDL.from_xml(@ddl_file)
        @ddl.get_language_set(UUID_3).should == @mock_language
    end
    
    it "should find a behavior_set given the right uuid" do
        @mock_behaviour.should_receive(:uuid).and_return(UUID_1)
        @ddl = DDL.from_xml(@ddl_file)
        @ddl.get_behavior_set(UUID_1).should == @mock_behaviour
    end
    
    it "should return nil if the module does not exist" do
        @mock_device.stub(:uuid => UUID_1)
        @mock_behaviour.stub(:uuid => UUID_2)
        @mock_language.stub(:uuid => UUID_3)
        @ddl = DDL.from_xml(@ddl_file)
        @ddl.get_module(nil).should == nil
    end
  end
  
  
  describe "adding modules" do
    it "should add a new device description" do
      DeviceDescription.should_receive(:new).with(@ddl,:uuid => "foo").and_return(device=mock(DeviceDescription))
      @ddl.add_device_description(:uuid => 'foo')
      @ddl.devices.should include(device)
    end
    
    it "should add a new behaviour set" do
      BehaviorSet.should_receive(:new).with(@ddl,:uuid => "foo").and_return(bs=mock(BehaviorSet))
      @ddl.add_behavior_set(:uuid => 'foo')
      @ddl.behavior_sets.should include(bs)
    end
    
    it "should add a new language set" do
      LanguageSet.should_receive(:new).with(@ddl,:uuid => "foo").and_return(ls=mock(LanguageSet))
      @ddl.add_language_set(:uuid => 'foo')
      @ddl.language_sets.should include(ls)
    end
  end
  
  describe "finding translations" do
    
    it "should have a language assigned"
    
    it "should ask the correct language set to translate a string" do
      #LanguageSet.unstub(:from_nokogiri) UNSTUB IS BREAKING SPECS IN OTHER FILES!!
      #@ddl = DDL.from_xml("<DDL version='1.0'><languageset uuid='#{UUID_1}'><language lang='en-gb'><string key='colr'>colour</string></language></languageset></DDL>")
      #@ddl.translate('colr',:en_GB,UUID_1).should == 'colour'
    end
  end

end