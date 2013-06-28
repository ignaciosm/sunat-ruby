require 'spec_helper'

describe SUNAT::PaymentAmount do
  describe "#[]" do    
    it "should be a pretty factory" do
      amount = PaymentAmount[117350, "PEN"]
      amount.currency.should == "PEN"
      amount.value.should == 117350
    end
  end
end