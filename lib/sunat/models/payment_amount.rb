module SUNAT

  class PaymentAmount
    include Model

    # Money amounts always in lowest common denominator, so integer only!
    property :value,    Integer
    property :currency, String
    
    validates :currency, currency_code: true
    
    def build_xml(xml, tag_name)
      xml['cbc'].send(tag_name, { currencyId: currency }, value)
    end
  end

end
