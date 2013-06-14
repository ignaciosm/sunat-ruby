module SUNAT
  
  class ValueFlatter
    attr_accessor :value, :model_flatter
    
    def initialize(model_flatter, value)
      self.model_flatter = model_flatter
      self.value = value
    end
    
    def flat
      if is_model?(value)
        flat_model(value)
      elsif is_array_of_model?(value)
        flat_array(value)
      else
        flat_plain(value)
      end
    end
    
    private
    
    def flat_array(list)
      list.map { |model| flat_model model }
    end
    
    def flat_model(model)
      self.model_flatter.flat_model(model)
    end
    
    def flat_plain(value)
      value
    end
    
    def is_model?(value)
      value.respond_to?(:is_model?) and value.is_model?
    end
  
    def is_array_of_model?(value)
      value.respond_to?(:contains_models?) and value.contains_models?
    end
  end
  
  class ModelFlatter
    attr_accessor :model
    
    def initialize(model)
      @model = model
    end
    
    def value
      flat_model model
    end
    
    def flat_model(model)
      model.reduce({}) do |flatted, (key, value)|
        unless value.nil?
          flatted[key.to_s] = flat_value(value)
        end
        
        flatted
      end
    end
    
    private
    
    def flat_value(value)
      flattener = ValueFlatter.new(self, value)
      flattener.flat
    end
  end
end