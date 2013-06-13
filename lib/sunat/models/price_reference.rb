module SUNAT
  class AlternativeConditionPrice
    include Model
    
    property :price_amount, PaymentAmount
    property :price_type,   String # TODO: Search for the valid price type codes
  end
  
  class PriceReference
    include Model
  end
end