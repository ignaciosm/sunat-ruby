require 'spec_helper'
require "sunat/models/allowance_charge"

describe SUNAT::AllowanceCharge do
  let :allowance_charge do
    SUNAT::AllowanceCharge.new
  end
  
  describe "validations" do
    it "should validate that the charge indicator is true or false and no other string" do
      allowance_charge.valid?.should eq(false)
      allowance_charge.charge_indicator = 'no-valid-word'
      allowance_charge.valid?.should eq(false)
      allowance_charge.charge_indicator = 'true'
      allowance_charge.valid?.should eq(true)
      allowance_charge.charge_indicator = 'no-valid-word'
      allowance_charge.valid?.should eq(false)
      allowance_charge.charge_indicator = 'false'
      allowance_charge.valid?.should eq(true)
    end
  end
end