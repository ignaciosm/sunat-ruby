module SUNAT
  class Country
    include Model
    
    property :identification_code, String # TODO: validates country code
  end
end