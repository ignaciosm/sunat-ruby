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
  end
end

# The Default Signature and Certificate is initially empty
SUNAT::SIGNATURE = SUNAT::Signature.new

# A method to allow override the default signature and certificate
def SUNAT.configure_signature
  yield SUNAT::SIGNATURE
end

# And we use this method to configure the signature
# TODO: FULL OF STUBS
SUNAT.configure_signature do |s|
  s.id          = "2010945"
  s.party_id    = "20100454523"
  s.party_name  = "SOPORTE TECNOLOGICO EIRL"
  s.uri         = "#SignST"
  
  cert_data = File.read(File.join(Dir.pwd, 'spec', 'sunat', 'support', 'test.crt'))
  s.build_certificate(cert_data)
  
  pk_data = File.read(File.join(Dir.pwd, 'spec', 'sunat', 'support', 'test.key'))
  s.build_private_key(pk_data)
end