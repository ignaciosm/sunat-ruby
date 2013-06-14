module SUNAT
  
  module Serializable
    def to_json
      MultiJson.dump(to_plain)
    end
    
    def to_plain
      ModelFlatter.new(self).value
    end
  end
end