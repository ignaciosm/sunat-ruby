module SUNAT  
  class PriceReference
    include Model
    
    property :alternative_condition_prices, [AlternativeConditionPrice]
    
    def initialize
      self.alternative_condition_prices = []
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