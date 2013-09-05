module SUNAT
  class AlternativeConditionPrice
    include Model
    
    property :price_amount, PaymentAmount
    property :price_type,   String, :default => '01'
    
    validates :price_type, inclusion: { in: ANNEX::CATALOG_16 }

    def initialize(*args)
      super(parse_attributes(*args))
    end
    
    def build_xml(xml)
      xml['cac'].AlternativeConditionPrice do
        price_amount.build_xml xml, :PriceAmount
        
        xml['cbc'].PriceTypeCode price_type
      end
    end

    protected

    def parse_attributes(attrs = {})
      if attrs.delete(:free)
        self.price_type = '02'
      end
      attrs
    end
    
  end
end
