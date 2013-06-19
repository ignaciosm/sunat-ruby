require 'spec_helper'

describe  do
  include SpecHelpers
  
  let :accounting_party do
    SUNAT::AccountingParty.new
  end
  
  describe "validations" do
    let(:invalid_code) { "124" }
    let(:valid_code) { ActiveModel::Validations::DocumentTypeCodeValidator::VALID_CODES.sample }
    
    it "should validate that the account_id needs to have 11 characters" do
      expect_invalid  accounting_party, :account_id, "1" * 5
      expect_valid    accounting_party, :account_id, "1" * 11
    end
    
    it "should validate that the additional_account_id is a valid document type code" do
      expect_invalid accounting_party,  :additional_account_id, invalid_code
      expect_valid accounting_party,    :additional_account_id, valid_code
    end
  end
  
  describe "#build_party_with_name" do
    it "should create a party with a party_name object with a name from the accounting_party object" do
      name = "name"
      accounting_party.build_party_with_name(name)
      accounting_party.party.name.should eq(name)
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