module SUNAT
  
  class PartyLegalEntity
    include Model
    
    property :registration_name, String
    
    def build_xml(xml)
      xml['cac'].PartyLegalEntity do
        xml['cbc'].RegistrationName registration_name
      end
    end
  end
end