module SUNAT

  class SummaryDocumentsLine
    include Model

    property :line_id,            String
    property :serial_id,          String
    property :start_id,           String
    property :end_id,             String
    property :document_type_code, String
    property :total_amount,       PaymentAmount
    property :billing_payments,   [BillingPayment]
    property :allowance_charges,  [AllowanceCharge]
    property :tax_totals,         [TaxTotal]
    
    [:line_id, :serial_id, :start_id, :end_id].each do |field|
      validates field, existence: true, presence: true
    end
    
    validates :document_type_code, tax_document_type_code: true
    
    def initialize
      self.billing_payments = []
      self.allowance_charges = []
      self.tax_totals = []
    end
  end

end
