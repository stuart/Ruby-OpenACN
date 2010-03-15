require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
include ACN::DDL

describe "Device Description" do
  describe "attributes" do
    before do
      @ddl = mock(DDL, :modules => [])
      @device = DeviceDescription.new(@ddl)
    end
    
    it "should have parameters" do
      @device.should respond_to(:parameters)
    end
    
    it "should have properties" do
      @device.should respond_to(:properties)
    end
    
    it "should have included_devices" do
      @device.should respond_to(:included_devices)
    end
    
    it "should have a parent device description" do
      @device.should respond_to(:parent)
    end
  end
  
  
  describe "device creation" do
    it "should accept a property" do
      
    end
    
  end
end