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
          end
        end
      end
      
      def build_notes(xml)
        document.notes.each do |note|
          xml['cbc'].Note(note)
        end
      end
    end
  end
end