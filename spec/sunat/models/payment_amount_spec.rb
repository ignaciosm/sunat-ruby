require 'spec_helper'

describe SUNAT::PaymentAmount do
  describe "#[]" do    
    it "should be a pretty factory" do
      amount = SUNAT::PaymentAmount[117350, "PEN"]
      amount.currency.should == "PEN"
      amount.value.should == 117350
    end
  end
  
  describe 'to_s' do
    it "should print a string" do
      SUNAT::PaymentAmount[117350, "PEN"].to_s.should == '1173.50'
    end
  end
end