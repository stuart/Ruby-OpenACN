require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
include ACN::DDL

describe "DDL Module" do
  
  before :all do
    @ddl = mock(ACN::DDL::DDL, :modules => [])
    @mod = DDLModule.new(@ddl, :uuid => "U#{UUID_1}")
    @ddl.stub!(:modules => [@mod])
  end
  
  describe "UUID" do
    it "should have a UUID" do
      @mod.uuid.should == UUID_1
    end
    
    it "should be unique" do
      lambda do
       @mod_2 = DDLModule.new(@ddl, :uuid => UUID_1)
      end.should raise_error "UUID is not unique"
    end
    
    it "should be a valid uuid" do
      lambda do
       @mod_2 = DDLModule.new(@ddl, :uuid => "Ufoo")
      end.should raise_error "UUID is invalid"
    end
    
    it "should find an actual UUID from a name" do
      @mod.uuid_names = {:foo => UUID_3}
      @mod.resolve_uuid('foo').should == UUID_3
    end
    
    it "find_uuid should return a UUID straight" do
      @mod.resolve_uuid(UUID_1).should == UUID_1
    end 
    
    it "should return nil when the UUID name does not exist" do
      @mod.resolve_uuid('bar').should be_nil
    end
    
    it "should set the UUID to a random UUID if none is supplied" do
      @mod = DDLModule.new(@ddl, :uuid => nil)
      UUID.validate(@mod.uuid).should be_true
    end
    
  end
  
  describe "label" do
    it "should be able to have a label" do
      @mod = DDLModule.new(@ddl, :uuid => UUID_2, :label =>{:text => "my label"})
      @mod.label.should == "my label"
    end
    
    it "should look up a translation if no text exists" do
      @ddl.stub(:modules).and_return([@mod])
      @mod = DDLModule.new(@ddl, :uuid => UUID_2, :label => {:key => "key", :set => UUID_1})
      @ddl.should_receive(:translate).with("key",UUID_1).and_return("my label")
      @mod.label.should == "my label"
    end
  end
  
  describe "alternatefor" do
    
  end
  
  describe "extends" do
    it "should find the existing module by UUID" do
      
    end
    
    it "should add it's properties to the existing module" do
      
    end
    
  end
  
  describe "parameters" do
    
  end
  
  
end