require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of a daily receipt summary' do
  
  before :all do
    @summary = DailyReceiptSummary.new.tap do |s|
      
    end
  end
  
  it "should do nothing" do
    puts "\nSUMMARY\n====="
    puts @summary.to_xml
  end
end