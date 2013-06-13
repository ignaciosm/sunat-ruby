module SUNAT
  class ModelFlatter
    attr_accessor :model
    
    def initialize(model)
      @model  = model
    end
    
    def value
      flat_model model
    end
    
    private
    
    def flat_model(model)
      model.reduce({}) do |flatted, (key, value)|
        if not value.nil?
          flatted[key.to_s] =  if is_model?(value)
            # value is a model
            flat_model value
          else
            value
          end
        end
        
        flatted
      end
    end
    
    def is_model?(value)
      value.respond_to?(:is_model?) and value.is_model?
    end
    
  end
end