module SUNAT
  module XMLBuilders
    class BasicBuilder
      attr_accessor :document, :signature
      
      DS_NAMESPACE  = 'http://www.w3.org/2000/09/xmldsig#'
      CAC_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
      CBC_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
      EXT_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'
      SAC_NAMESPACE = 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1'
      XSI_NAMESPACE = 'http://www.w3.org/2001/XMLSchema-instance'
      
      C14N_ALGORITHM            = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
      DIGEST_ALGORITHM          = "http://www.w3.org/2000/09/xmldsig#sha1"
      SIGNATURE_ALGORITHM       = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
      TRANSFORMATION_ALGORITHM  = "http://www.w3.org/2000/09/xmldsig#enveloped- signature"
      
      DATE_FORMAT = "%Y-%m-%d"
      
      CUSTOMIZATION_ID = "1.0"
      UBL_VERSION_ID = "2.0"
      
      ADDITIONAL_ROOT_ATTRIBUTES = {}
      
      def initialize(document)
        self.document = document
        self.signature = SUNAT::SIGNATURE # this is created in sunat/signature.rb
      end
      
      def get_xml
        # must be implemented. WARN!
        warn "#{self.class.name} should implement get_xml for #{document.class.name} class."
      end
      
      protected
      
      def format_date(date)
        date.strftime(DATE_FORMAT)
      end
      
      def make_xml(tag_name, &block)
        builder = xml_builder do |xml|
          build_root xml, tag_name, &block
        end
        builder = add_soap_digital_signatures(builder)
        builder.to_xml
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
          'xmlns:ds'    => DS_NAMESPACE,
          'xmlns:ext'   => EXT_NAMESPACE,
          'xmlns:sac'   => SAC_NAMESPACE,
          'xmlns:xsi'   => XSI_NAMESPACE
        }.merge(self.class::ADDITIONAL_ROOT_ATTRIBUTES)
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
        
        if signed_info.present?
          canon = signed_info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ['soap', 'web'])
          # Add the signature to the document
          signed_value = doc.xpath('//ds:SignatureValue', 'ds' => DS_NAMESPACE).first
          signed_value.content = signature_for(canon)
        else
          warn 'there is no SignedInfo in this xml to put the signature.'
        end

        doc
      end
      
      def build_general_data(xml)
        xml['cbc'].UBLVersionID         UBL_VERSION_ID
        xml['cbc'].CustomizationID      CUSTOMIZATION_ID
        xml['cbc'].ID                   document.id
        xml['cbc'].IssueDate            format_date(document.issue_date)
      end
      
      def build_ubl_extensions(xml, &proc)
        if not block_given?
          proc = Proc.new do
            build_additional_information_extension(xml)
            build_signature_extension(xml)
          end
        end
        
        xml['ext'].UBLExtensions(&proc)
      end
      
      def build_extension(xml, &block)
        xml['ext'].UBLExtension do
          xml['ext'].ExtensionContent(&block)
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
          xml['ds'].DigestValue '' # TODO: digest placeholder
        end
      end
    
      def build_signature_value(xml)
        xml['ds'].SignatureValue '' # TODO: signature base64 encoded placeholder
      end
    
      def build_signature_key_info(xml)
        xml['ds'].KeyInfo do
          xml['ds'].X509Data do
            certificate = signature.certificate
            xml['ds'].X509SubjectName certificate.issuer
            xml['ds'].X509Certificate certificate.cert
          end
        end
      end
    
      def build_signature_extension(xml)
        build_extension xml do
          xml['ds'].Signature(Id: signature.id) do
            build_signature_signed_info(xml)
            build_signature_value(xml)
            build_signature_key_info(xml)
          end
        end
      end
      
      def build_general_signature_information(xml)
        xml['cac'].Signature do
          xml['cbc'].ID signature.id
        
          xml['cac'].SignatoryParty do
            xml['cac'].PartyIdentification do
              xml['cbc'].ID signature.party_id
            end
            xml['cac'].PartyName do
              xml['cbc'].Name signature.party_name
            end
          end
        
          xml['cac'].DigitalSignatureAttachment do
            xml['cac'].ExternalReference do
              xml['cbc'].URI signature.uri
            end
          end
        end
      end
      
      def build_accounting_party(xml, top_level_party, &continuation)
        xml['cbc'].CustomerAssignedAccountID top_level_party.account_id
        xml['cbc'].AdditionalAccountID top_level_party.additional_account_id
        
        party = top_level_party.party
        
        xml['cac'].Party do
          
          if party.name.present?
            xml['cac'].PartyName do
              xml['cbc'].Name party.name
            end
          end
          
          if party.postal_addresses.any?
            party.postal_addresses.each do |address|
              xml['cac'].PostalAddress do
                xml['cbc'].ID                   address.id
                xml['cbc'].StreetName           address.street_name
                xml['cbc'].CitySubdivisionName  address.city_subdivision_name
                xml['cbc'].CountrySubentity     address.country_subentity
                xml['cbc'].District             address.district
                xml['cac'].Country do
                  xml['cbc'].IdentificationCode address.country.identification_code
                end
              end
            end
          end
          
          if party.party_legal_entities.any?
            party.party_legal_entities.each do |entity|
              xml['cac'].PartyLegalEntity do
                xml['cbc'].RegistrationName entity.registration_name
              end
            end
            build_party_physical_location xml, party
          end
        end
      end
      
      def build_party_physical_location(xml, party)
        # implements if necesary.
      end
      
      def build_accounting_customer_party(xml)        
        xml['cac'].AccountingCustomerParty do
          build_accounting_party xml, invoice.accounting_customer_party
        end
      end
      
      def build_accounting_supplier_party(xml, supplier = invoice.accounting_supplier_party)
        xml['cac'].AccountingSupplierParty do
          build_accounting_party xml, supplier
        end
      end
      
      def signature_for(text)
        signature.signature_for(text)
      end
      
      def digest_for(text)
        OpenSSL::Digest::SHA1.new.base64digest(text)
      end
      
    end
  end
end