module SUNAT
  module XMLBuilders
    class DailyReceiptSummaryBuilder < BasicBuilder
      
      ADDITIONAL_ROOT_ATTRIBUTES = {
        'xsi:schemaLocation' => 'urn:sunat:names:specification:ubl:peru:schema:xsd:InvoiceSummary-1 D:\UBL_SUNAT\SUNAT_xml_20110112\20110112\xsd\maindoc\UBLPE-InvoiceSummary-1.0.xsd'
      }
      
      def get_xml
        make_xml :SummaryDocuments do |xml|
          build_ubl_extensions xml do
            build_signature_extension(xml)
          end
        end
      end      
    end
  end
end