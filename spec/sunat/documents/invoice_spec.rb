require 'spec_helper'

describe SUNAT::Invoice do
  include ValidationSpecHelpers
  include SupportingSpecHelpers
  
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
  
  describe "#file_name" do
    before :all do
      @invoice = eval_support_script("serialization/invoice_sample")
    end
    
    it "should have a voucher_serie" do
      @invoice.voucher_serie.should_not be_nil
    end
    
    it "should have a voucher_serie of 4 characters" do
      @invoice.voucher_serie.size.should eq(4)
    end
    
    it "include all the parts of the invoice file name" do
      ruc = @invoice.ruc
      kind = @invoice.class::DOCUMENT_TYPE_CODE
      serie = @invoice.voucher_serie
      correlative_number = @invoice.correlative_number
      
      @invoice.file_name.should eq("#{ruc}-#{kind}-#{serie}-#{correlative_number}")
    end
  end
end