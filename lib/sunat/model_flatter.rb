module SUNAT
  class ModelFlatter
    attr_accessor :model
    
    def initialize(model)
      @model  = model
      @flat   = Hash.new
    end
    
    def [](attr)
      @model[attr]
    end
    
    def value
      flat_model
      @flat
    end
    
    private
    
    def value_of(model)
      flatter = self.class.new(model)
      flatter.value
    end
    
    def flat_model
      @model.each do |key, value|
        next if value.nil?
        
        key = key.to_s
        if is_model?(value)
          referenced = value
          
          @flat[key] = value_of(referenced)
        else
          @flat[key] = value
        end
      end
    end
    
    private
    
    def is_model?(value)
      value.respond_to?(:is_model?) and value.is_model?
    end
    
  end
end