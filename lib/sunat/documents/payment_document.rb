module SUNAT  
  module PaymentDocument
        
    def self.extended(base)
      base.send :include, HasTaxTotals
      
      base.xml_root :Invoice
                
      base.property :id,                              String # serie + correlative number
      base.property :invoice_type_code,               String
      base.property :document_currency_code,          String
      base.property :accounting_customer_party,       AccountingParty
      base.property :legal_monetary_total,            PaymentAmount
      base.property :lines,                           [InvoiceLine]
      base.property :depatch_document_references,     [ReferralGuideline] # spanish: Guías de remisión
      base.property :additional_document_references,  [DocumentReference]
      base.property :tax_totals,                      [TaxTotal]
      
      base.validates :document_currency_code, existence: true, currency_code: true
      base.validates :invoice_type_code, tax_document_type_code: true
      
      base.class_eval do
        def initialize(*args)
          super(*args)
          self.lines ||= []
          self.tax_totals ||= []
          self.depatch_document_references ||= []
          self.additional_document_references ||= []
          self.invoice_type_code ||= self.class::DOCUMENT_TYPE_CODE
          self.document_currency_code ||= "PEN" # currency code by default
        end
        
        def file_name
          document_type_code = self.class::DOCUMENT_TYPE_CODE
          "#{ruc}-#{document_type_code}-#{id}"
        end
        
        def operation
          :send_bill
        end
        
        def id
          self[:id] ||= "#{voucher_serie}-#{correlative_number}"
        end
        
        def add_line(&block)
          line = InvoiceLine.new.tap(&block)
          line.id = get_line_number.to_s
          self.lines << line
        end
        
        # refactor..meh :P It depends a lot
        def make_accounting_customer_party(options)
          dni = options[:dni]
          ruc = options[:ruc]
          name = options[:name]
          
          doc_code = dni ? Document::DNI_DOCUMENT_CODE : Document::RUC_DOCUMENT_CODE
          doc_number = dni || ruc
          build_party_method = dni ? :build_party_with_name : :build_party_with_legal_name
          
          self.accounting_customer_party = AccountingParty.new.tap do |p|
            if doc_number.present?
              p.additional_account_id = doc_code
              p.account_id = doc_number
            end
            p.send(build_party_method, name)
          end
        end
        
        def to_xml
          super do |xml|
            xml['cbc'].InvoiceTypeCode      invoice_type_code
            xml['cbc'].DocumentCurrencyCode document_currency_code
            
            accounting_supplier_party.build_xml xml, :AccountingSupplierParty
            
            # sunat said that, if no customer exists, we must use a dash.
            if accounting_customer_party.present?
              accounting_customer_party.build_xml xml, :AccountingCustomerParty
            else
              xml['cac'].AccountingCustomerParty "-"
            end
            
            tax_totals.each do |total|
              total.build_xml xml
            end
            
            xml['cac'].LegalMonetaryTotal do
              legal_monetary_total.build xml, :PayableAmount
            end if legal_monetary_total.present?
            
            lines.each do |line|
              line.build_xml xml
            end            
          end
        end
        
        private
        
        def get_line_number
          @current_line_number ||= 0
          @current_line_number += 1
          @current_line_number
        end

      end
    end
  end
end