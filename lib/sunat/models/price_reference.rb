module SUNAT
  
  class AlternativeConditionPrice
    include Model
    
    PRICE_TYPES_HASH = {
      '01' => 'Precio Unitario.',
      '02' => 'Valor referencial unitario en operaciones no onerosas.'
    }
    
    property :price_amount, PaymentAmount
    property :price_type,   String
    
    validates :price_type, inclusion: { in: PRICE_TYPES_HASH.keys }
  end
  
  class PriceReference
    include Model
    
    property :alternative_condition_prices, [AlternativeConditionPrice]
    
    def initialize
      self.alternative_condition_prices = []
    end
  end
end