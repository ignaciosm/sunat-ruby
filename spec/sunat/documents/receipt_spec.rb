require 'spec_helper'

describe SUNAT::Receipt do
  include ValidationSpecHelpers
  include SupportingSpecHelpers
  
  let :receipt do
    SUNAT::Receipt.new
  end
  
  describe "#initialize" do    
    it "should begins with the correct DOCUMENT_TYPE_CODE" do
      receipt.invoice_type_code.should == SUNAT::Receipt::DOCUMENT_TYPE_CODE
    end
    
    it "should begins with a document_currency_code by default" do
      receipt.document_currency_code.should_not be_nil
    end
  end
  
  describe '#id' do
    it 'should have an id based in his correlative number' do
      receipt.correlative_number = "10"
      receipt.id.should == "#{receipt.voucher_serie}-10"
    end
  end
end