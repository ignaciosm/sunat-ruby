module SUNAT
  module XMLBuilders
    class BasicBuilder
      attr_accessor :document, :signature
      
      DS_NAMESPACE  = 'http://www.w3.org/2000/09/xmldsig#'
      CAC_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
      CBC_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
      CTC_NAMESPACE = 'urn:un:unece:uncefact:documentation:2'
      EXT_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'
      QDT_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2'
      SAC_NAMESPACE = 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1'
      UDT_NAMESPACE = 'urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2'
      XSI_NAMESPACE = 'http://www.w3.org/2001/XMLSchema-instance'
      
      def initialize(document)
        self.document = document
        self.signature = SUNAT::SIGNATURE # this is created in sunat/signature.r
      end
      
      protected
      
      def format_date(date)
        date.strftime(DATE_FORMAT)
      end
      
      def xml_builder(&proc)
        # There is no way to add standalone=no without using `with`
        # see: http://goo.gl/jyJp4
        declaration = Nokogiri::XML('<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>')
        Nokogiri::XML::Builder.with(declaration, &proc)
      end
      
      def build_root(xml, tag_name, &block)
        attributes = {
          'xmlns'       => 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
          'xmlns:cac'   => CAC_NAMESPACE,
          'xmlns:cbc'   => CBC_NAMESPACE,
          'xmlns:ccts'  => CTC_NAMESPACE,
          'xmlns:ds'    => DS_NAMESPACE,
          'xmlns:ext'   => EXT_NAMESPACE,
          'xmlns:qdt'   => QDT_NAMESPACE,
          'xmlns:sac'   => SAC_NAMESPACE,
          'xmlns:udt'   => UDT_NAMESPACE,
          'xmlns:xsi'   => XSI_NAMESPACE
        }
        xml.send(tag_name, attributes, &block)
      end
      
      def add_soap_digital_signatures(xml)
        # To get round silly namespace issues and help canonicalization,
        # reload the doc
        doc = Nokogiri::XML.parse(xml.doc.to_xml)

        # Set the digest
        digest = doc.xpath('//ds:DigestValue', 'ds' => DS_NAMESPACE).first
        # digest.content = digest_for(text)
        # TODO: I don't know WHAT i should digest

        # Prepare the SignedInfo for the signature
        signed_info = doc.xpath('//ds:SignedInfo', 'ds' => DS_NAMESPACE).first
        canon = signed_info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ['soap', 'web'])

        # Add the signature to the document
        signed_value = doc.xpath('//ds:SignatureValue', 'ds' => DS_NAMESPACE).first
        signed_value.content = signature_for(canon)

        doc
      end
      
    end
  end
end