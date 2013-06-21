module SUNAT
  class XMLSigner < SimpleDelegator
    def sign(xml_string)
      unsigned_document = build_from_xml(xml_string)
      
      search_signature_location(unsigned_document) do |location|
        # location
      end
      
      xml_string
      # builder = add_soap_digital_signatures(builder)
    end
    
    private
    
    def search_signature_location(document, &block)
      element = document.xpath("//ext:ExtensionContent[not(node())]").first
      if element.present?
        block.call(element)
      else
        warn 'there is not an empty ExtensionContent to put the signature'
      end
    end
    
    # old
    
    def build_signature_extension(xml)
      build_extension xml do
        xml['ds'].Signature(Id: signature.id) do
          build_signature_signed_info(xml)
          build_signature_value(xml)
          build_signature_key_info(xml)
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
        xml['ds'].DigestValue '' # TODO: digest placeholder
      end
    end

    def build_signature_value(xml)
      xml['ds'].SignatureValue '' # PLACEHOLDER: signature base64 encoded placeholder
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

    def add_soap_digital_signatures(xml)
      # To get round silly namespace issues and help canonicalization,
      # reload the doc
      doc = Nokogiri::XML.parse(xml.doc.to_xml)

      # Set the digest
      digest = doc.xpath('//ds:DigestValue', 'ds' => DS_NAMESPACE).first
      # digest.content = digest_for(text)
      # TODO: I don't know WHAT i should digest

      find_signed_info(doc) do |signed_info|
        canon = canonicalize(signed_info)
        # Add the signature to the document
        signed_value = doc.xpath('//ds:SignatureValue', 'ds' => DS_NAMESPACE).first
        signed_value.content = signature_for(canon)
      end

      doc
    end

    def find_signed_info(doc, &block)
      # Prepare the SignedInfo for the signature
      signed_info = doc.xpath('//ds:SignedInfo', 'ds' => DS_NAMESPACE).first
      if signed_info.present?
        block.call(signed_info)
      else
        warn 'there is no SignedInfo in this xml to put the signature.'
      end
    end

    def canonicalize(signed_info)
      signed_info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ['soap', 'web'])
    end

    def signature_for(text)
      signature.signature_for(text)
    end

    def digest_for(text)
      OpenSSL::Digest::SHA1.new.base64digest(text)
    end
  end
end