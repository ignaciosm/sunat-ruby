module SUNAT
  class BaseBuilder
    
    DS_NAMESPACE        = 'http://www.w3.org/2000/09/xmldsig#'
    CAC_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
    CBC_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
    EXT_NAMESPACE       = 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'
    SAC_NAMESPACE       = 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1'
    XSI_NAMESPACE       = 'http://www.w3.org/2001/XMLSchema-instance'
    XSI_SCHEMA_LOCATION = 'urn:sunat:names:specification:ubl:peru:schema:xsd:InvoiceSummary-1 D:\UBL_SUNAT\SUNAT_xml_20110112\20110112\xsd\maindoc\UBLPE-InvoiceSummary-1.0.xsd'
    
    C14N_ALGORITHM            = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
    DIGEST_ALGORITHM          = "http://www.w3.org/2000/09/xmldsig#sha1"
    SIGNATURE_ALGORITHM       = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
    TRANSFORMATION_ALGORITHM  = "http://www.w3.org/2000/09/xmldsig#enveloped- signature"
    
    DATE_FORMAT = "%Y-%m-%d"
    
    CUSTOMIZATION_ID = "1.0"
    UBL_VERSION_ID = "2.0"
    
    def self.build(document, root_name, &block)
      builder = self.new
      builder.root_name = root_name
      builder.document = document
      builder.build(&block)
    end
    
    attr_accessor :root_name, :document, :signature
    
    def initialize
      self.signature = SUNAT::SIGNATURE
    end
    
    def build(&block)
      builder = Nokogiri::XML::Builder.with(declaration) do |xml|
        build_root xml do
          build_ubl_extensions xml
          build_general_data xml
          signature.to_xml xml
          
          block.call self, xml
        end
      end
      
      builder = add_soap_digital_signatures(builder)
      builder.to_xml
    end
    
    private
    
    def format_date(date)
      date.strftime(DATE_FORMAT)
    end
    
    def declaration
      @_declaration ||= Nokogiri::XML('<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>')
    end
    
    def build_root(xml, &block)
      attributes = {
        'xmlns'               => 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
        'xmlns:cac'           => CAC_NAMESPACE,
        'xmlns:cbc'           => CBC_NAMESPACE,
        'xmlns:ds'            => DS_NAMESPACE,
        'xmlns:ext'           => EXT_NAMESPACE,
        'xmlns:sac'           => SAC_NAMESPACE,
        'xmlns:xsi'           => XSI_NAMESPACE,
        'xsi:schemaLocation'  => XSI_SCHEMA_LOCATION
      }
      xml.send(root_name, attributes, &block)
    end
    
    def build_general_data(xml)
      xml['cbc'].UBLVersionID         UBL_VERSION_ID
      xml['cbc'].CustomizationID      CUSTOMIZATION_ID
      xml['cbc'].ID                   document.id
      xml['cbc'].IssueDate            format_date(document.issue_date)
    end
    
    def build_ubl_extensions(xml)        
      xml['ext'].UBLExtensions do
        build_additional_information_extension xml
        build_signature_extension xml
      end
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
    
    def additional_monetary_totals
      self.document.additional_monetary_totals
    end
  
    def additional_properties
      self.document.additional_properties
    end
    
    def build_additional_information_extension(xml)
      build_extension xml do
        xml['sac'].AdditionalInformation do
          additional_monetary_totals.each do |additional_monetary_total|
            additional_monetary_total.build_xml xml
          end
          additional_properties.each do |property|
            property.build_xml xml
          end
        end
      end
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
    
    def signature_for(text)
      signature.signature_for(text)
    end
    
    def digest_for(text)
      OpenSSL::Digest::SHA1.new.base64digest(text)
    end
    
  end
end