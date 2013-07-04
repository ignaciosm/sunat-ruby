require 'spec_helper'
require "sunat/models/summary_documents_line"

describe SUNAT::SummaryDocumentsLine do
  let :line do
    SUNAT::SummaryDocumentsLine.new
  end
  
  describe "#initialize" do
    it "should initialize with 0 billing_payments." do
      line.billing_payments.should_not be_nil
      line.billing_payments.should be_empty
    end
    
    it "should have a default document_type_code" do
      line.document_type_code.should == SUNAT::Receipt::DOCUMENT_TYPE_CODE
    end
  end
  
  describe '#add_billing_payment' do
    it 'should add a billing_payment/paid_amount to the line' do
      line.add_billing_payment(1200, "PEN")
      
      line.billing_payments.size.should eq(1)
      line.billing_payments.first.should be_kind_of(SUNAT::BillingPayment)
      line.billing_payments.first.paid_amount.should be_kind_of(SUNAT::PaymentAmount)
      line.billing_payments.first.instruction_id.should_not be_nil
    end
    
    it 'should increment the instruction_id' do
      5.times do
        line.add_billing_payment(1200, "PEN")
      end
      
      line.billing_payments.map(&:instruction_id).should == ['01', '02', '03', '04', '05']
    end
  end
  
  describe '#add_allowance_charge & #add_allowance_discount' do
    it 'should add a charge to the line' do
      line.add_allowance_charge(10000, 'USD')
      line.allowance_charges.size.should == 1
    end
    
    it 'should set the amount of the charge to the params of the method' do
      v, c = [1000, 'USD']
      line.add_allowance_charge(v, c)
      
      charge = line.allowance_charges.first
      charge.amount.currency.should == c
      charge.amount.value.should == v
    end
  end
  
  describe '#add_allowance_charge' do
    it 'should set the charge_indicator to "true"' do
      line.add_allowance_charge(10000, 'USD')
      charge = line.allowance_charges.first
      charge.charge_indicator.should == "true"
    end
  end
  
  describe '#add_allowance_discount' do
    it 'should set the charge_indicator to "false"' do
      line.add_allowance_discount(10000, 'USD')
      charge = line.allowance_charges.first
      charge.charge_indicator.should == "false"
    end
  end
  
  describe '#total_amount' do
    def test_with_7_amounts(amounts)
      a, b, c, d, e, f, g = amounts
      
      line.add_billing_payment a, "PEN"
      line.add_billing_payment b, "PEN"
      line.add_billing_payment c, "PEN"
    
      line.add_allowance_charge d, "PEN"
      line.add_allowance_discount e, "PEN"
    
      line.add_tax_total :isc, f, "PEN"
      line.add_tax_total :igv, g, "PEN"
      
      line.total_amount.value.should eq(amounts.inject(&:+))
    end
        
    it 'should sum all the positive amounts' do
      test_with_7_amounts [9823200, 0, 23200, 500, 0, 0, 1768100]
    end
    
    it 'can substract when some negative value are found' do
      # the 5th value is a discount, so this should work
      test_with_7_amounts [9823200, 0, 23200, 500, 500, 0, 1768100]
    end
  end
end