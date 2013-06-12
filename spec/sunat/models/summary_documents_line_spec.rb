require 'spec_helper'
require "sunat/models/summary_documents_line"

describe SUNAT::SummaryDocumentsLine do
  let :line do
    SUNAT::SummaryDocumentsLine.new
  end
  
  describe ".new" do
    it "should initialize with 0 billing_payments." do
      line.billing_payments.should_not be_nil
      line.billing_payments.should be_empty
    end
  end
end