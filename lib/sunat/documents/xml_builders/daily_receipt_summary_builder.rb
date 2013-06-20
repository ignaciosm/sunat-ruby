module SUNAT
  module XMLBuilders
    class DailyReceiptSummaryBuilder < BasicBuilder
      
      ADDITIONAL_ROOT_ATTRIBUTES = {
        'xsi:schemaLocation' => 'urn:sunat:names:specification:ubl:peru:schema:xsd:InvoiceSummary-1 D:\UBL_SUNAT\SUNAT_xml_20110112\20110112\xsd\maindoc\UBLPE-InvoiceSummary-1.0.xsd'
      }
      
      def get_xml
        make_xml :SummaryDocuments do |xml|
          build_ubl_extensions xml do
            build_signature_extension xml
            build_general_data xml
            build_notes xml
            build_general_signature_information xml            
            build_accounting_supplier_party xml, document.accounting_supplier
            build_lines xml
          end
        end
      end
      
      private
      
      def build_notes(xml)
        document.notes.each do |note|
          xml['cbc'].Note(note)
        end
      end
      
      def build_lines(xml)
        document.lines.each do |line|
          build_line xml, line
        end
      end
      
      def build_line(xml, line)
        xml['sac'].SummaryDocumentsLine do
          xml['cbc'].LineID line.line_id
          xml['cbc'].DocumentTypeCode line.document_type_code
          xml['sac'].DocumentSerialID line.serial_id
          xml['sac'].StartDocumentNumberID line.start_id
          xml['sac'].EndDocumentNumberID line.end_id
          
          build_tax_totals xml, line.tax_totals
          build_allowance_charges xml, line.allowance_charges
          
          line.billing_payments.each do |payment|
            build_billing_payment xml, payment
          end
        end
      end
      
      def build_allowance_charges(xml, charges)
        charges.each do |charge|
          build_allowance_charge xml, charge
        end
      end
      
      def build_allowance_charge(xml, charge)
        xml['cac'].AllowanceCharge do
          xml['cbc'].ChargeIndicator charge.charge_indicator
          build_money xml, 'cbc', :Amount, charge.amount
        end
      end
      
      def build_billing_payment(xml, payment)
        xml['sac'].BillingPayment do
          build_money xml, 'cbc', :PaidAmount, payment.paid_amount
          xml['cbc'].InstructionID payment.instruction_id
        end
      end
      
    end
  end
end