require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
include ACN::DDL

describe "Device Description" do
   before do
      @ddl = mock(DDL, :modules => [])
   end
  
  describe "attributes" do
    before do
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
    it "should accept property array" do
      @device = DeviceDescription.new(@ddl, :properties => [@mock_prop = mock(Property)])
      @device.properties.should == [@mock_prop]
    end
    
    it "should accept a parameter array" do
      @device = DeviceDescription.new(@ddl, :parameters => [@mock_param = mock(Parameter)])
      @device.parameters.should == [@mock_param]
    end
    
    it "should accept a parent" do
      @device = DeviceDescription.new(@ddl, :parent => @mock_device = mock(DeviceDescription))
      @device.parent.should == @mock_device
    end
  end
  
  describe "Declaration of Sub Devices" do
    
    describe "having no circular references" do
      
    it "should raise an error if trying to make self as parent" do
      @device = DeviceDescription.new(@ddl)
      lambda do
        @device.parent = @device
      end.should raise_error(ArgumentError)
    end
    
    it "should not raise an error given a new device as parent" do
      @device = DeviceDescription.new(@ddl)
      @device2 = DeviceDescription.new(@ddl)
      lambda do
        @device.parent = @device2
      end.should_not raise_error(ArgumentError)
    end
    
    end
    
    
  end

end