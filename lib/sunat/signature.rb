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
    attr_accessor :certificate, :id, :party_id, :party_name, :uri
    
    def build_certificate(*args)
      cert = Certificate.new(*args)
      yield cert if block_given?
      self.certificate = cert
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
  s.id = "2010945"
  s.party_id = "20100454523"
  s.party_name = "SOPORTE TECNOLOGICO EIRL"
  s.uri = "#SignST"
  
  cert_data = File.read(File.join(Dir.pwd, 'spec', 'sunat', 'support', 'test.crt'))
  s.build_certificate(cert_data)
end