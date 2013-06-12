module SUNAT

  class AllowanceCharge
    include Model

    property :amount,           PaymentAmount
    property :charge_indicator, String
    
    validates :charge_indicator, inclusion: { in: ['true', 'false'] }
  end

end
