module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    
    property :id,                             String
    property :invoice_type_code,              String # TODO: Range in Catalog # 01
    property :document_currency_code,         String
    property :accounting_supplier_party,      AccountingParty
    property :accounting_customer_party,      AccountingParty
    property :legal_monetary_total,           PaymentAmount
    property :depatch_document_references,    [DocumentReference] # spanish: Guías de remisión
    property :additional_document_references, [DocumentReference]
    property :invoice_lines,                  [InvoiceLine]
    
    validates :document_currency_code, existence: true, currency_code: true
  end
end