module SUNAT
  class Certificate
    attr_reader :cert
    
    def initialize(certificate_data)
      @cert = OpenSSL::X509::Certificate.new(certificate_data)
    end
    
    def issuer
      cert.issuer.to_s.split(/\//).reject{|n| n.to_s.empty?}.join(',')
    end
  end
  
  class Signature
    attr_accessor :certificate, :id, :party_id, :party_name, :uri, :private_key
    
    def build_certificate(*args)
      cert = Certificate.new(*args)
      yield cert if block_given?
      self.certificate = cert
    end
    
    def build_private_key(private_key)
      self.private_key = OpenSSL::PKey::RSA.new(private_key)
    end
    
    def signature_for(text)
      Base64.strict_encode64(
        self.private_key.sign(OpenSSL::Digest::SHA1.new, text)
      )
    end
    
    def xml_metadata(xml)
      xml['cac'].Signature do
        xml['cbc'].ID id
      
        xml['cac'].SignatoryParty do
          xml['cac'].PartyIdentification do
            xml['cbc'].ID party_id
          end
          xml['cac'].PartyName do
            xml['cbc'].Name party_name
          end
        end
      
        xml['cac'].DigitalSignatureAttachment do
          xml['cac'].ExternalReference do
            xml['cbc'].URI uri
          end
        end
      end
    end
  end
end