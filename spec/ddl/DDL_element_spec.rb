require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
include ACN::DDL

describe "DDL Element" do
  before(:each) do
    @ddl = DDL.new()
    @module = DDLModule.new(@ddl)
    @element = DDLElement.new(@module)
  end
  
  it "should have a uuid" do
    @element.should respond_to(:uuid)
  end
  
  it "should set the uuid" do
    UUID_1 = UUID.generate
    @module.uuid_names = {}
    @element = DDLElement.new(@module, :uuid => UUID_1)
    @element.uuid.should == UUID_1
  end
  
  it "should set the uuid from the owning module's uuid_names" do
    UUID_1 = UUID.generate
    @module.uuid_names = {:foo => UUID_1}
    @element = DDLElement.new(@module, :uuid => 'foo')
    @element.uuid.should == UUID_1
  end
  
end