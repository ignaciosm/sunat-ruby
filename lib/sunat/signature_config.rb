# The Default Signature and Certificate is initially empty
SUNAT::SIGNATURE = SUNAT::Signature.new

# Allow override the default signature and certificate in a DSL-like style
def SUNAT.configure_signature
  yield SUNAT::SIGNATURE
end

# TODO: FULL OF STUBS

# And we use this method to configure the signature
SUNAT.configure_signature do |s|
  s.id          = "2010945"
  s.party_id    = "20100454523"
  s.party_name  = "SOPORTE TECNOLOGICO EIRL"
  s.uri         = "#SignST"
  
  cert_data = File.read(File.join(Dir.pwd, 'spec', 'sunat', 'support', 'test.crt'))
  s.build_certificate(cert_data)
  
  pk_data = File.read(File.join(Dir.pwd, 'spec', 'sunat', 'support', 'test_decrypted.key'))
  s.build_private_key(pk_data)
end