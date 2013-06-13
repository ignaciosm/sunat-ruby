module SUNAT
  
  module Serializable
    def to_json
      plain = ModelFlatter.new(self)
      MultiJson.dump(plain.value)
    end
    
    def is_model?
      true
    end
  end
end