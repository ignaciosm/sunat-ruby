# The Default Signature and Certificate is initially empty
SUNAT::SIGNATURE = SUNAT::Signature.new
SUNAT::CREDENTIALS = SUNAT::Credentials.new

class SUNAT::ConfigurationDSL  
  def credentials
    yield SUNAT::CREDENTIALS
  end
  
  def signature
    yield SUNAT::SIGNATURE
  end
end

# Allow override the default signature and certificate in a DSL-like style
def SUNAT.configure
  yield SUNAT::ConfigurationDSL.new
end