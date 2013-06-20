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
    
    def build_xml(xml)
      xml['sac'].SummaryDocumentsLine do
        xml['cbc'].LineID                 line_id
        xml['cbc'].DocumentTypeCode       document_type_code
        xml['sac'].DocumentSerialID       serial_id
        xml['sac'].StartDocumentNumberID  start_id
        xml['sac'].EndDocumentNumberID    end_id
        
        tax_totals.each do |total|
          total.build_xml xml
        end
        
        allowance_charges.each do |charge|
          charge.build_xml xml
        end
        
        billing_payments.each do |billing_payment|
          billing_payment.build_xml xml
        end
      end
    end
    
    
  end

end
