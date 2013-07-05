require 'spec_helper'

describe SUNAT::InvoiceLine do
  let :line do
    SUNAT::InvoiceLine.new
  end
  
  describe '#make_quantity' do
    it 'should create the invoiced_quantity property from a Quantity object' do
      line.make_quantity 300, "CS"
      
      line.invoiced_quantity.should_not be_nil
      line.invoiced_quantity.quantity.should == 300
      line.invoiced_quantity.unit_code.should == "CS"
    end
  end
  
  describe '#make_selling_price' do
    it 'should create the line_extension_amount property' do
      line.make_selling_price 172890, "PEN"
    
      line.line_extension_amount.should_not be_nil
      line.line_extension_amount.value.should == 172890
      line.line_extension_amount.currency.should == "PEN"
    end
  end
  
  describe '#make_unitary_price' do
    it 'should create the price property' do
      line.make_unitary_price 172890, "PEN"
    
      line.price.should_not be_nil
      line.price.value.should == 172890
      line.price.currency.should == "PEN"
    end
  end
  
  shared_examples 'a price reference generator' do |method, code|
    it 'should create a pricing reference with one AlternativeConditionPrice with the code 01 and the price given' do
      line.send(method, 17288000, "PEN")
      
      line.pricing_reference.tap do |ref|
        ref.should_not be_nil
        ref.should be_kind_of(SUNAT::PriceReference)
        ref.alternative_condition_prices.size.should == 1
        ref.alternative_condition_prices.first.tap do |acp|
          acp.should be_kind_of(SUNAT::AlternativeConditionPrice)
          acp.price_type.should == code
          acp.price_amount.currency.should == "PEN"
          acp.price_amount.value.should == 17288000
        end
      end
    end
    
    it 'should create only one AlternativeConditionPrice if is called twice' do
      line.send(method, 17288000, "PEN")
      line.send(method, 17288000, "PEN")
      line.pricing_reference.alternative_condition_prices.size.should == 1
    end
  end
  
  describe '#make_paid_price' do
    it_behaves_like 'a price reference generator', :make_paid_price, '01'
  end
  
  describe '#make_referencial_unitary_price' do
    it_behaves_like 'a price reference generator', :make_referencial_unitary_price, '02'
  end

end