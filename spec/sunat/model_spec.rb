require 'spec_helper'

describe SUNAT::Model do

  describe "#initialize" do

    before :each do
      @model = Class.new do
        include SUNAT::Model
        property :name, String
      end
    end

    it "should accept nil" do
      expect {
        @obj = @model.new
      }.to_not raise_error
    end

    it "should accept and set attributes" do
      @obj = @model.new(:name => "Sam")
      @obj.name.should eql("Sam")
    end

  end

end

