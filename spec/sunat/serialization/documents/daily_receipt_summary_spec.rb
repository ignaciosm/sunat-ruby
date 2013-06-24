require 'spec_helper'

include SUNAT
# for more succinct calls

describe 'serialization of a daily receipt summary' do
  include SupportingSpecHelpers
  
  before :all do
    @summary = eval_support_script("serialization/daily_receipt_summary_sample")
    @xml = Nokogiri::XML(@summary.to_xml)
  end
  
  it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
    date = @xml.xpath("//cbc:IssueDate")
    date.count.should == 1
    date.text.should eq(Date.today.strftime("%Y-%m-%d"))
  end
  
  it "should have a root named SummaryDocuments" do
    @xml.root.name.should eq("SummaryDocuments")
  end
  
  it "should have a cbc:ID tag named with the id of the summary" do
    @xml.xpath("/*/cbc:ID").first.text.should eq(@summary.id)
  end
  
  it "should have many cbc:Note tags containing the contents of the notes" do
    @xml.xpath("//cbc:Note").map do |node|
      node.text
    end.should eq(@summary.notes.to_a)
  end
  
  describe "node AccountingSupplier" do
    it "should have CustomerAssignedAccountID equivalent to the account_id" do
      @xml.xpath("//cbc:CustomerAssignedAccountID").text.should eq(@summary.accounting_supplier_party.account_id)
    end
    it "should have AdditionalAccountID equivalent to the additional_account_id" do
      @xml.xpath("//cbc:AdditionalAccountID").text.should eq(@summary.accounting_supplier_party.additional_account_id)
    end
    
    describe "node Party" do
      it "should insert a entity name into the xml" do
        entity_name_location = "//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"
        xml_entity_name = @xml.xpath(entity_name_location).text
        oo_entity_name = @summary.accounting_supplier_party.party.party_legal_entities.first.registration_name
        
        xml_entity_name.should eq(oo_entity_name)
      end
    end
  end
  
end