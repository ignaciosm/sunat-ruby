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
    
    def is_for_paid_price?
      price_type == PRICE_TYPES[:selling_price]
    end
    
    def is_for_referencial_price?
      price_type == PRICE_TYPES[:reference_selling_price]
    end
    
    PRICE_TYPES = {
      selling_price: '01',
      reference_selling_price: '02'
    }
    
    class << self      
      def with_paid_price(amount, currency)
        add_with_price_type(:selling_price, amount, currency)
      end
      
      def with_referencial_price(amount, currency)
        add_with_price_type(:reference_selling_price, amount, currency)
      end
      
      private
      
      def add_with_price_type(price_type, amount, currency)
        self.new.tap do |acp|
          acp.price_type = PRICE_TYPES[price_type]
          acp.price_amount = PaymentAmount[amount, currency]
        end
      end
    end
  end
end