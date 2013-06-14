require 'spec_helper'

describe  do
  let :accounting_supplier_party do
    SUNAT::AccountingParty.new
  end
  
  describe "validations" do    
    it "should validate that the account_id needs to have 11 characters" do
      accounting_supplier_party.valid?.should eq(false)
      accounting_supplier_party.account_id = "1" * 5
      accounting_supplier_party.valid?.should eq(false)
      accounting_supplier_party.account_id = "1" * 11
      accounting_supplier_party.valid?.should eq(true)
    end
  end
end