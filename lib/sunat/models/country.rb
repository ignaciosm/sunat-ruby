module SUNAT
  
  class Country
    include Model
    
    property :identification_code, String
    
    validates :identification_code, length: { is: 2 }
  end
end