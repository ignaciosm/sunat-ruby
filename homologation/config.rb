
# Sample SUNAT configuration

SUNAT.configure do |config|
  config.credentials do |c|
    c.ruc       = "20548704261"
    c.username  = "CABIFY01"
    c.password  = "cU74P5Xl"
  end
  
  config.signature do |s|
    s.party_id    = "20548704261"
    s.party_name  = "MAXI MOBILITY PERU S.A.C."
    s.cert_file   = File.join(Dir.pwd, 'keys', 'sunat.crt')
    s.pk_file     = File.join(Dir.pwd, 'keys', 'sunat.key')
  end

  config.supplier do |s|
    s.name       = "MAXI MOBILITY PERU S.A.C."
    s.ruc        = "201548704261"
    s.address_id = "070101"
    s.street     = "Calle los Olivos 234"
    s.city       = "Lima"
    s.district   = "Callao"
    s.country    = "PE"
  end
end

