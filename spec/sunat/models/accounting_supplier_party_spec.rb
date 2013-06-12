require 'spec_helper'
require "sunat/models/accounting_supplier_party"

describe SUNAT::AccountingSupplierParty do
  let :accounting_supplier_party do
    SUNAT::AccountingSupplierParty.new
  end
  
  describe "validations" do
    it "should validate that the additional_account_id attribute is a valid document code"
    
    it "should validate that the account_id needs to have 11 characters" do
      accounting_supplier_party.valid?.should eq(false)
      accounting_supplier_party.account_id = "1" * 5
      accounting_supplier_party.valid?.should eq(false)
      accounting_supplier_party.account_id = "1" * 11
      accounting_supplier_party.valid?.should eq(true)
    end
  end
end