module SUNAT

  class AllowanceCharge
    include Model

    property :amount,           PaymentAmount
    property :charge_indicator, String

  end

end
