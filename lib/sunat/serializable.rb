module SUNAT
  
  module Serializable
    def to_json
      plain = ModelFlatter.new(self)
      MultiJson.dump(plain.value)
    end
  end
end