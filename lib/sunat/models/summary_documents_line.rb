require "sunat/models/billing_payment"

module SUNAT

  class SummaryDocumentsLine
    include Model

    property :serial_id, String
    property :start_id,  String
    property :end_id,    String

    property :billing_payments, [BillingPayment]

  end

end
