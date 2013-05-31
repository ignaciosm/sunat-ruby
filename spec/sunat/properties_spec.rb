require 'spec_helper'

describe SUNAT::Attributes do

  before :each do
    @model = Class.new do
      include SUNAT::Model
      property :name, String
    end
    @obj = @model.new
  end


  describe "#get_attribute" do
    it "should provide object in model" do
      @obj[:key1] = 'value'
      @obj.get_attribute(:key1).should eql('value')
    end
  end

  describe "#set_attribute" do
    it "should be posible to set attribute not defined as property" do
      @obj.set_attribute('key1', 'value1')
      @obj.set_attribute(:key2, 'value2')
      @obj[:key1].should eql('value1')
      @obj[:key2].should eql('value2')
    end

    it "should set and cast attribute with property" do
      property = @model.send(:properties)[:name]
      name = "Fred Flinstone"
      property.should_receive(:cast).with(@obj, name).and_return(name)
      @obj.set_attribute(:name, name)
      @obj[:name].should eql(name)
    end
  end


end
