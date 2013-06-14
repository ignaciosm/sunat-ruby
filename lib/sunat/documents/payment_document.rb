module SUNAT
  
  module PaymentDocument
    
    def self.extended(base)
      base.property :id,                             String # serie + correlative number
      base.property :invoice_type_code,              String # TODO: Range in Catalog # 01
      base.property :document_currency_code,         String
      base.property :accounting_supplier_party,      AccountingParty
      base.property :accounting_customer_party,      AccountingParty
      base.property :legal_monetary_total,           PaymentAmount
      base.property :depatch_document_references,    [DocumentReference] # spanish: Guías de remisión
      base.property :additional_document_references, [DocumentReference]
      base.property :tax_totals,                     [TaxTotal]
      base.property :invoice_lines,                  [InvoiceLine]
      
      base.validates :document_currency_code, existence: true, currency_code: true
    end
  end
end