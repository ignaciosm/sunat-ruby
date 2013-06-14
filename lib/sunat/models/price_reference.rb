module SUNAT
  
  class AlternativeConditionPrice
    include Model
    
    property :price_amount, PaymentAmount
    property :price_type,   String # TODO: Range in Catalog # 16
  end
  
  class PriceReference
    include Model
  end
end