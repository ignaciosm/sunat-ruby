module SUNAT
  class Invoice
    include Model
    
    property :id,                             String
    property :invoice_type_code,              String # TODO: invoice type code is a number. Find the range of value later.
    property :document_currency_code,         String # TODO: Research rules of currency codes valid for ISO 4217
    property :accounting_supplier_party,      AccountingParty
    property :accounting_customer_party,      AccountingParty
    property :legal_monetary_total,           PaymentAmount
    property :depatch_document_references,    [DocumentReference] # spanish: Guías de remisión
    property :additional_document_references, [DocumentReference]
    property :invoice_lines,                  [InvoiceLine]
  end
end