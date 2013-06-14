require 'spec_helper'

describe SUNAT::Invoice do
  describe "validations" do
    let :invoice do
      SUNAT::Invoice.new
    end
    
    it 'should valid that document_currency_code is a valid code' do
      invoice.valid?.should eq(false)
      invoice.document_currency_code = "PEN"
      invoice.valid?.should eq(true)
      invoice.document_currency_code = "123"
      invoice.valid?.should eq(true)
      invoice.document_currency_code = "12P"
      invoice.valid?.should eq(false)
      invoice.document_currency_code = "PE04"
      invoice.valid?.should eq(false)
    end
  end
end