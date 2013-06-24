require "spec_helper"

include SUNAT::Delivery

describe Sender do
  include SupportingSpecHelpers
  
  before :all do
    @summary        = eval_support_script("serialization/daily_receipt_summary_sample")
    @document       = @summary.to_xml
    @name           = @summary.file_name
    @operation_list = @summary.operation_list
    @chef           = Chef.new(@name, @document)
    @encoded_zip    = @chef.prepare
  end
  
  let :sender do
    Sender.new(@name, @encoded_zip, @operation_list)
  end
  
  describe "#initialize" do    
    it "receives a name and encoded_zip" do
      sender.name.should == @name
      sender.encoded_zip.should == @encoded_zip
      sender.operation_list.should == @operation_list
    end
  end
  
  describe "#connect" do
    it "should get a list of operations" do
      sender.connect
      sender.client.services.tap do |it|
        it.should_not be_nil
        it.should respond_to(:size)
        it.size.should > 0
      end
    end
  end
  
  describe "#build" do
    it "should build a xml example document" do
      sender.connect
      sender.build
      sender.operation.body[:sendSummary][:fileName].should == @name
      sender.operation.body[:sendSummary][:contentFile].should == @encoded_zip
    end
  end
  
  describe "#send" do
    it "should call send" do
      sender.send
    end
  end

end