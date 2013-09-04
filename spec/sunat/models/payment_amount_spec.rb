require 'spec_helper'

describe SUNAT::PaymentAmount do
  describe ".new" do
    it "should handle a string" do
      amount = SUNAT::PaymentAmount.new("12345")
      amount.value.should eql(12345)
      amount.currency.should eql("PEN")
    end
    it "should handle an integer" do
      amount = SUNAT::PaymentAmount.new(123457)
      amount.value.should eql(123457)
      amount.currency.should eql("PEN")
    end
    it "should handle a hash" do
      amount = SUNAT::PaymentAmount.new(:value => 123456)
      amount.value.should eql(123456)
      amount.currency.should eql("PEN")
    end
  end

  describe "#[]" do    
    it "should be a pretty factory" do
      amount = SUNAT::PaymentAmount[117350, "PEN"]
      amount.currency.should == "PEN"
      amount.value.should == 117350
    end

    it "should accept amount without currency" do
      amount = SUNAT::PaymentAmount[11289]
      amount.currency.should eql('PEN')
      amount.value.should eql(11289)
    end
  end
  
  describe 'to_s' do
    it "should print a string" do
      SUNAT::PaymentAmount[117350, "PEN"].to_s.should == '1173.50'
    end
  end
end
