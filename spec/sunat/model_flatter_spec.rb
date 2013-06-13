require 'spec_helper'

describe SUNAT::ModelFlatter do
  
  let :flatter_klass do
    SUNAT::ModelFlatter
  end
  
  describe ".initialize" do
    let :model do
      klass = Class.new do
        include SUNAT::Model
        
        property :name, String
      end
      
      klass.new({ name: 'mundo'})
    end
    
    it "should construct a presenter" do
      f = flatter_klass.new(model)
      f.model.name.should eq(model.name)
    end
  end
  
  context "With a plain model" do
    before(:all) do
      @klass = Class.new do
        include SUNAT::Model
      
        property :name, String
        property :age,  Fixnum
      end
      @data = { 'name' => 'name', 'age' => 45 }
      @model = @klass.new(@data)
    end
  
    let :flatter do
      flatter_klass.new(@model)
    end
  
    describe ".value" do
      it "should transform @plain_model into a dictionary of name and age" do
        flatter.value.should eq(@data)
      end
    end
  end
  
  context "with a referenced object" do
    before(:all) do
      @aux_klass = Class.new do
        include SUNAT::Model
        
        property :age, Fixnum
      end
      
      Kernel.const_set("Auxiliary", @aux_klass)
      
      @klass = Class.new do
        include SUNAT::Model
      
        property :name, String
        property :aux,  Auxiliary
      end
      
      @aux_model = @aux_klass.new
      @aux_model.age = 100
      
      @model = @klass.new
      @model.name = "name"
      @model.aux = Auxiliary.new(age: 20)
    end
  
    let :flatter do
      flatter_klass.new(@model)
    end
  
    describe ".value" do
      it "should transform a model with a reference into a dictionary where the referece is in a key" do
        expected = {
          'name' => 'name',
          'aux' => {
            'age' => 20
          }
        }
        flatter.value.should eq(expected)
      end
    end
  end
  
end