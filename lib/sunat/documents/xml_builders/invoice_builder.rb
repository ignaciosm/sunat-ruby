module SUNAT
  module XMLBuilders
    class InvoiceBuilder
      attr_accessor :invoice
      
      DATE_FORMAT = "%Y-%m-%d"
      
      C14N_ALGORITHM            = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
      SIGNATURE_ALGORITHM       = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
      TRANSFORMATION_ALGORITHM  = "http://www.w3.org/2000/09/xmldsig#enveloped- signature"
      DIGEST_ALGORITHM          = "http://www.w3.org/2000/09/xmldsig#sha1"
      
      def initialize(invoice)
        self.invoice = invoice
      end
      
      def get_xml        
        builder = xml_builder do |xml|
          build_root xml do
            build_ubl_extensions xml
            build_general_data xml
            build_general_signature_information xml            
            # NEXT: <cac:AccountingSupplierParty>
            
          end
        end
      
        builder.to_xml
      end
    
      private
      
      def format_date(date)
        date.strftime(DATE_FORMAT)
      end
      
      def xml_builder(&proc)
        # There is no way to add standalone=no without using with
        # see: http://goo.gl/jyJp4
        declaration = Nokogiri::XML('<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>')
        Nokogiri::XML::Builder.with(declaration, &proc)
      end
      
      def build_general_data(xml)
        xml['cbc'].UBLVersionID "2.0"
        xml['cbc'].CustomizationID "1.0" # TODO: Research
        xml['cbc'].ID invoice.id
        xml['cbc'].IssueDate format_date(invoice.issue_date)
        xml['cbc'].InvoiceTypeCode invoice.invoice_type_code
        xml['cbc'].DocumentCurrencyCode invoice.document_currency_code
      end
      
      def build_general_signature_information(xml)
        xml['cac'].Signature do
          xml['cbc'].ID 'IDSignKG' # TODO: Research
        end
        
        xml['cac'].SignatoryParty do
          xml['cac'].PartyIdentification do
            xml['cbc'].Id "20100454523" # TODO: Research
          end
          xml['cac'].PartyName do
            xml['cbc'].Name "SOPORTE TECNOLOGICO EIRL" # TODO: Research
          end
        end
        
        xml['cac'].DigitalSignatureAttachment do
          xml['cac'].ExternalReference do
            xml['cbc'].URI "#SignST" # TODO: Research
          end
        end
      end
    
      def build_root(xml, &block)
        attributes = {
          'xmlns'       => 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
          'xmlns:cac'   => 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
          'xmlns:cbc'   => 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
          'xmlns:ccts'  => 'urn:un:unece:uncefact:documentation:2',
          'xmlns:ds'    => 'http://www.w3.org/2000/09/xmldsig#',
          'xmlns:ext'   => 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2',
          'xmlns:qdt'   => 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2',
          'xmlns:sac'   => 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1',
          'xmlns:udt'   => 'urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2',
          'xmlns:xsi'   => 'http://www.w3.org/2001/XMLSchema-instance'
        }
        xml.Invoice(attributes, &block)
      end
    
      # STUB
      def additional_monetary_totals
        [
          { id: 1001, currency: "PEN", amount: 348199.15 },
          { id: 1003, currency: "PEN", amount: 12350.00 },
          { id: 2005, currency: "PEN", amount: 59230.51 }
        ]
      end
    
      # STUB
      def additional_properties
        [
          { id: 1000, value: "CUATROCIENTOS VEINTITRES MIL DOSCIENTOS VEINTICINCO Y 00/100" }
        ]
      end
    
      def build_extension(xml, &block)
        xml['ext'].UBLExtension do
          xml['ext'].ExtensionContent(&block)
        end
      end
    
      def build_additional_information_extension(xml)
        build_extension xml do
          xml['sac'].AdditionalInformation do
            additional_monetary_totals.each do |total|
              xml['sac'].AdditionalMonetaryTotal do
                xml['cbc'].ID total[:id]
                xml['cbc'].PayableAmount({currencyID: total[:currency]}, total[:amount])
              end
            end
            additional_properties.each do |property|
              xml['sac'].AdditionalProperty do
                xml['cbc'].ID property[:id]
                xml['cbc'].Value property[:value]
              end
            end
          end
        end
      end
    
      def build_signature_signed_info(xml)
        xml['ds'].SignedInfo do
          xml['ds'].CanonicalizationMethod(Algorithm: C14N_ALGORITHM)
          xml['ds'].SignatureMethod(Algorithm: SIGNATURE_ALGORITHM)
          xml['ds'].Reference(URI: "")
          xml['ds'].Transforms do
            xml['ds'].Transform(Algorithm: TRANSFORMATION_ALGORITHM)
          end
          xml['ds'].DigestMethod(Algorithm: DIGEST_ALGORITHM)
          xml['ds'].DigestValue '' # TODO: Hash codified in Base64
        end
      end
    
      def build_signature_value(xml)
        xml['ds'].SignatureMethod '' # TODO: signature codified in Base64
      end
    
      def build_signature_key_info(xml)
        xml['ds'].KeyInfo do
          xml['ds'].X509Data do
            xml['ds'].X509SubjectName '' # TODO: Research
            xml['ds'].X509Certificate '' # TODO: Certificate information
          end
        end
      end
    
      def build_signature_extension(xml)
        build_extension xml do
          xml['ds'].Signature(Id: 'SignatureSP') do
            build_signature_signed_info(xml)
            build_signature_value(xml)
            build_signature_key_info(xml)
          end
        end
      end
    
      def build_ubl_extensions(xml)
        xml['ext'].UBLExtensions do
          build_additional_information_extension(xml)
          build_signature_extension(xml)
        end
      end
      
    end
  end
end