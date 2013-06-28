require "spec_helper"

describe SUNAT::Document do
  include SupportingSpecHelpers
  
  before(:all) do
    @empty_receipt   = SUNAT::DailyReceiptSummary.new
    @daily_receipt   = eval_support_script("serialization/daily_receipt_summary_sample")
    @invoice         = eval_support_script("serialization/invoice_sample")
  end
  
  let(:ruc) { "20548704261" }
  
  it "has a ruc" do
    @daily_receipt.ruc.should_not be_nil
  end
  
  it "has a valid ruc" do
    @daily_receipt.ruc.size.should be(11)
  end
  
  it "can add a ruc" do    
    @empty_receipt.ruc = ruc
    
    @empty_receipt.ruc.should_not be_nil
    @empty_receipt.ruc.should eq(ruc)
  end
  
  it "should add additional_account_id with a default value when adding a ruc" do
    @empty_receipt.ruc = ruc
    
    @empty_receipt.accounting_supplier_party.additional_account_id.should eq(SUNAT::Document::RUC_DOCUMENT_CODE)
  end
  
  it "can add a legal name" do
    legal_name = "Maxi Mobility"
    
    @empty_receipt.legal_name = legal_name
    @empty_receipt.accounting_supplier_party.should_not be_nil
    @empty_receipt.accounting_supplier_party.party.should_not be_nil
    @empty_receipt.accounting_supplier_party.party.party_legal_entities.first.registration_name.should == legal_name
  end
  
  it "has a non-abstract file_name" do
    expect { @daily_receipt.file_name }.to_not raise_error
    expect { @invoice.file_name }.to_not raise_error
  end
  
end