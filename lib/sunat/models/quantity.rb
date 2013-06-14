module SUNAT
  
  class Quantity
    include Model
    
    property :quantity,   Fixnum
    property :unit_code,  String # unit codes as defined in UN/ECE rec 20
  end
end