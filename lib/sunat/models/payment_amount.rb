module SUNAT

  class PaymentAmount
    include Model

    # Money amounts always in lowest common denominator, so integer only!
    property :value,    Integer
    property :currency, String
    
    validates :currency, currency_code: true 
  end

end
