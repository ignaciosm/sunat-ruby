require "sunat/models/billing_payment"
require "sunat/models/payment_amount"

module SUNAT

  class SummaryDocumentsLine
    include Model

    property :line_id,            String
    property :serial_id,          String
    property :start_id,           String
    property :end_id,             String
    property :document_type_code, String # Check AccountingSupplierParty#additional_account_id

    property :total_amount,       PaymentAmount
    
    [:line_id, :serial_id, :start_id, :end_id].each do |field|
      validates field, existence: true, presence: true
    end

    property :billing_payments, [BillingPayment]
  end

end
