require 'spec_helper'
require "sunat/models/accounting_supplier_party"

describe SUNAT::DailyReceiptSummary do
  
  let :summary do
    SUNAT::DailyReceiptSummary.new
  end
  
  let :account_supplier do
    SUNAT::AccountingSupplierParty.new
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
    
    it "should initialize the issue_date with the current date." do
      summary.issue_date.should eq(Date.today)
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
