module SUNAT

  class PaymentAmount
    include Model

    # Money amounts always in lowest common denominator, so integer only!
    property :value,    Integer
    property :currency, String
    
    # in the xml, the currency must me in the format: [0-9]+.[0-9]{2}
    validates :currency, currency_code: true
    
    def build_xml(xml, tag_name)
      xml['cbc'].send(tag_name, { currencyId: currency }, to_s)
    end
    
    def to_s
      int_part = value / 100
      cents_part = value % 100
      "#{int_part}.#{cents_part}"
    end
    
    class << self
      def [](value, currency)
        self.new.tap do |payment|
          payment.value = value
          payment.currency = currency
        end
      end
    end
  end
end
