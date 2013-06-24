require "spec_helper"

describe SUNAT::Document do
  include SupportingSpecHelpers
  
  before(:all) do
    @daily_receipt   = eval_support_script("serialization/daily_receipt_summary_sample")
    @invoice         = eval_support_script("serialization/invoice_sample")
  end
  
  it "has a ruc" do
    @daily_receipt.ruc.should_not be_nil
  end
  
  it "has a valid ruc" do
    @daily_receipt.ruc.size.should be(11)
  end
  
  it "has a non-abstract file_name" do
    expect { @daily_receipt.file_name }.to_not raise_error
    expect { @invoice.file_name }.to_not raise_error
  end
  
end