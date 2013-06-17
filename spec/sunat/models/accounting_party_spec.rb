require 'spec_helper'

describe  do
  let :accounting_party do
    SUNAT::AccountingParty.new
  end
  
  describe "validations" do    
    it "should validate that the account_id needs to have 11 characters" do
      accounting_party.valid?.should eq(false)
      accounting_party.account_id = "1" * 5
      accounting_party.valid?.should eq(false)
      accounting_party.account_id = "1" * 11
      accounting_party.valid?.should eq(true)
    end
  end
  
  describe "#build_party_with_name" do
    it "should create a party with a party_name object with a name from the accounting_party object" do
      name = "name"
      accounting_party.build_party_with_name(name)
      accounting_party.party.party_name.name.should eq(name)
    end
    
    it "should create a party with some part_legal_entity with a registration_name from the accounting_party object" do
      a, b = "a", "b"
      accounting_party.build_party_with_legal_name a, b
      
      names = accounting_party.party.party_legal_entities.map do |entity|
        entity.registration_name
      end
      
      names.should include(a)
      names.should include(b)
    end
  end
end