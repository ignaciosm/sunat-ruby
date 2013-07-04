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

end