module SUNAT
  class ReferralGuideline < DocumentReference
    DOCUMENT_CODE = '09' # referral guideline
    
    def initialize
      super
      self.document_type_code = DOCUMENT_CODE
    end
  end
  
  class AdditionalProperty
    include Model
    
    property :id,     String
    property :name,   String
    property :value,  String
  end
  
  class MonetaryTotal
    include Model
    
    property :id,               String
    property :payable_amount,   PaymentAmount
    property :reference_amount, PaymentAmount
    property :total_amount,     PaymentAmount
    property :percent,          Float    
  end
  
  module PaymentDocument
    
    INVOICE = '01'
    PAYSTUB = '03'
    
    def self.extended(base)      
      base.property :id,                              String # serie + correlative number
      base.property :invoice_type_code,               String
      base.property :document_currency_code,          String
      base.property :accounting_supplier_party,       AccountingParty
      base.property :accounting_customer_party,       AccountingParty
      base.property :legal_monetary_total,            PaymentAmount
      base.property :invoice_lines,                   [InvoiceLine]
      base.property :depatch_document_references,     [ReferralGuideline] # spanish: Guías de remisión
      base.property :additional_document_references,  [DocumentReference]
      base.property :tax_totals,                      [TaxTotal]
      base.property :additional_monetary_totals,      [MonetaryTotal]
      base.property :additional_properties,           [AdditionalProperty]
      
      base.validates :document_currency_code, existence: true, currency_code: true
      base.validates :invoice_type_code, tax_document_type_code: true
      
      base.class_eval do
        def initialize
          super
          self.invoice_lines = []
          self.tax_totals = []
          self.depatch_document_references = []
          self.additional_document_references = []
          self.additional_monetary_totals = []
          self.additional_properties = []
          self.invoice_type_code = self.class::DOCUMENT_TYPE_CODE
        end
        
        def add_additional_property(options)
          id = options[:id]
          name = options[:name]
          value = options[:value]
          
          self.additional_properties << AdditionalProperty.new.tap do |property|
            property.id = id        if id
            property.name = name    if name
            property.value = value  if value
          end
        end
        
      end
    end
  end
end