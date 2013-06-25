require "spec_helper"

include SUNAT
include SUNAT::Delivery

describe Sender do
  include SupportingSpecHelpers
  
  before :all do
    @summary        = eval_support_script("serialization/daily_receipt_summary_sample")
    @document       = @summary.to_xml
    @name           = @summary.file_name
    @operation      = @summary.operation
    @chef           = Chef.new(@name, @document)
    @encoded_zip    = @chef.prepare
  end
  
  let(:ruc)      { ENV['SUNAT_RUC'] }
  let(:username) { ENV['SUNAT_USERNAME'] }
  let(:password) { ENV['SUNAT_PASSWORD'] }
  
  let :sender do
    sender = Sender.new(@name, @encoded_zip, @operation)
    sender.auth_with ruc, username, password
    sender
  end
  
  describe "#initialize" do    
    it "receives a name and encoded_zip" do
      sender.name.should == @name
      sender.encoded_zip.should == @encoded_zip
      sender.operation.should == @operation
    end
  end
  
  describe "#connect" do
    it "should get a list of operations" do
      sender.connect
      sender.client.operations.tap do |it|
        it.should_not be_nil
        it.should respond_to(:size)
        it.size.should > 0
      end
    end
  end
  
  describe "#send" do    
    it "should call send" do
      expect do
        sender.call
      end.to_not raise_error
    end
  end

end