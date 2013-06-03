module SUNAT

  class BillingPayment
    include Model

    property :paid_amount,    PaymentAmount
    property :instruction_id, String

  end

end
