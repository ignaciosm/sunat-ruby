require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of a receipt' do
  include SupportingSpecHelpers
  
  before :all do
    @receipt = eval_support_script("serialization/receipt_sample")
    @xml = Nokogiri::XML(@receipt.to_xml)
  end
  
  it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
    date = @xml.xpath("//cbc:IssueDate")
    date.count.should >= 0
    date.text.should eq(Date.today.strftime("%Y-%m-%d"))
  end

end