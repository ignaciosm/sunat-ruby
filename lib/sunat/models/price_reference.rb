module SUNAT  
  class PriceReference
    include Model
    
    property :alternative_condition_prices, [AlternativeConditionPrice]
    
    def initialize
      self.alternative_condition_prices = []
    end
    
    def add_paid_alternative_condition_price(amount, currency)
      alternative_condition_prices << AlternativeConditionPrice.with_paid_price(amount, currency)
    end
    
    def add_referencial_condition_price(amount, currency)
      alternative_condition_prices << AlternativeConditionPrice.with_referencial_price(amount, currency)
    end
    
    def build_xml(xml)
      xml['cac'].PricingReference do
        alternative_condition_prices.each do |alternative_condition_price|
          alternative_condition_price.build_xml xml
        end
      end
    end
    
  end
end