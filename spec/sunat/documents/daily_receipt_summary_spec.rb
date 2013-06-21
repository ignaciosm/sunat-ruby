require 'spec_helper'

describe SUNAT::DailyReceiptSummary do
  
  let :summary do
    SUNAT::DailyReceiptSummary.new
  end
  
  let :account_supplier do
    SUNAT::AccountingParty.new
  end
  
  describe ".new" do
    it "should initialize with no notes." do
      summary.notes.should_not be_nil
      summary.notes.should be_empty
    end
    
    it "should initialize with no lines." do
      summary.lines.should_not be_nil
      summary.lines.should be_empty
    end
    
    it "should have a default id starting with RC- and containing the current date in format YYYYMMDD" do
      formatted_date = Date.today.strftime("%Y%m%d")
      
      summary.id.should_not be_nil
      summary.id.should start_with("RC-")
      summary.id.should end_with(formatted_date)
    end
  end
  
  describe "validations" do
    it "should be valid only with an accounting supplier." do
      summary.valid?.should eq(false)
      summary.accounting_supplier = account_supplier
      summary.valid?.should eq(true)
    end
  end
  
end
