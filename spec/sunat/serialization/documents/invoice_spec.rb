require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of an invoice' do
  include SupportingSpecHelpers
  
  before :all do
    @invoice = eval_support_script("serialization/invoice_sample")
    @xml = Nokogiri::XML(@invoice.to_xml)
  end
  
  it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
    date = @xml.xpath("//cbc:IssueDate")
    date.count.should >= 0
    date.text.should eq(Date.today.strftime("%Y-%m-%d"))
  end
  
  # it "should insert the payment amount into the xml body" do
  #   payable_amount_tag = @xml.xpath("//sac:AdditionalMonetaryTotal/cbc:PayableAmount")
  #   payable_amount_tag.count.should >= 0
  #   payable_amount_tag.text.should eq(@invoice.additional_monetary_totals.first.payable_amount.to_s)
  # end
end