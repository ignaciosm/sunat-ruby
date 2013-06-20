require 'spec_helper'

describe SUNAT::Invoice do
  include ValidationSpecHelpers
  
  let :invoice do
    SUNAT::Invoice.new
  end
  
  describe "#initialize" do
    it "should begins with the correct DOCUMENT_TYPE_CODE" do
      invoice.invoice_type_code.should eq(SUNAT::Invoice::DOCUMENT_TYPE_CODE)
    end
  end
  
  describe "validations" do    
    it 'should valid that document_currency_code is a valid code' do
      expect_valid    invoice, :document_currency_code, "PEN"
      expect_valid    invoice, :document_currency_code, "123"
      expect_invalid  invoice, :document_currency_code, "12P"
      expect_invalid  invoice, :document_currency_code, "PE04"
    end
    
    it "should valid that invoice_type_code is a valid code" do
      expect_invalid  invoice, :invoice_type_code, "AB"
      expect_invalid  invoice, :invoice_type_code, "013"
      expect_valid    invoice, :invoice_type_code, "12"
    end
  end
end