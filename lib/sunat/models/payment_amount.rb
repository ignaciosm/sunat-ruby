module SUNAT

  class PaymentAmount
    include Model

    # Money amounts always in lowest common denominator, so integer only!
    property :value,    Integer
    property :currency, String
    # in the xml, the currency must me in the format: [0-9]+.[0-9]{2}
    
    validates :currency, currency_code: true
    
    def build_xml(xml, tag_name)
      xml['cbc'].send(tag_name, { currencyId: currency }, value)
    end
  end
end
