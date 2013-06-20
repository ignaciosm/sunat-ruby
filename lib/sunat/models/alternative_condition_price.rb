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
    
    def build_xml(xml)
      xml['cac'].AlternativeConditionPrice do
        price_amount.build_xml xml, :PriceAmount
        
        xml['cbc'].PriceTypeCode price_type
      end
    end
  end
end