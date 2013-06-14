module SUNAT

  class SummaryDocumentsLine
    include Model

    property :line_id,            String
    property :serial_id,          String
    property :start_id,           String
    property :end_id,             String
    property :document_type_code, String # TODO: Range in Catalog # 01
    property :total_amount,       PaymentAmount
    property :billing_payments,   [BillingPayment]
    property :allowance_charges,  [AllowanceCharge]
    property :tax_totals,         [TaxTotal]
    
    [:line_id, :serial_id, :start_id, :end_id].each do |field|
      validates field, existence: true, presence: true
    end
    
    def initialize
      self.billing_payments = []
      self.allowance_charges = []
    end
  end

end
