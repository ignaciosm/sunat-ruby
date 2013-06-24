module SUNAT  
  module PaymentDocument
        
    def self.extended(base)
      base.xml_root :Invoice
                
      base.property :id,                              String # serie + correlative number
      base.property :invoice_type_code,               String
      base.property :document_currency_code,          String
      base.property :accounting_customer_party,       AccountingParty
      base.property :legal_monetary_total,            PaymentAmount
      base.property :invoice_lines,                   [InvoiceLine]
      base.property :depatch_document_references,     [ReferralGuideline] # spanish: Guías de remisión
      base.property :additional_document_references,  [DocumentReference]
      base.property :tax_totals,                      [TaxTotal]
      
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
        
        def file_name
          document_type_code = self.class::DOCUMENT_TYPE_CODE
          "#{ruc}-#{document_type_code}-#{voucher_serie}-#{correlative_number}"
        end
        
        def operation
          :send_bill
        end
        
        def to_xml
          super do |xml|
            xml['cbc'].InvoiceTypeCode      invoice_type_code
            xml['cbc'].DocumentCurrencyCode document_currency_code
            
            accounting_supplier_party.build_xml xml, :AccountingSupplierParty
            accounting_customer_party.build_xml xml, :AccountingCustomerParty
            
            tax_totals.each do |total|
              total.build_xml xml
            end
            
            xml['cac'].LegalMonetaryTotal do
              legal_monetary_total.build xml, :PayableAmount
            end if legal_monetary_total.present?
            
            invoice_lines.each do |invoice_line|
              invoice_line.build_xml xml
            end            
          end
        end

      end
    end
  end
end