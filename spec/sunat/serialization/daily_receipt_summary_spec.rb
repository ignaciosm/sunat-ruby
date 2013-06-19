require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of a daily receipt summary' do
  
  before :all do
    @summary = DailyReceiptSummary.new.tap do |s|
      s.id              = "RC-20120624-001"
      s.reference_date  = Date.strptime("2012-06-23", "%Y-%m-%d")
      s.notes           = ["nota 1", "nota 2", "nota3"]
      
      s.build_accounting_supplier do |supplier|
        supplier.account_id = "20100113612"
        supplier.additional_account_id = "6"
        supplier.build_party_with_legal_name "K&G Laboratorios"
      end
      
      s.lines << SummaryDocumentLine.new.tap do |line|
        
      end
    end
  end
  
  it "should do nothing" do
    puts "\nSUMMARY\n====="
    puts @summary.to_xml
  end
end