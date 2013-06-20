module SUNAT
  
  class Country
    include Model
    
    property :identification_code, String
    
    validates :identification_code, length: { is: 2 }
    
    def build_xml(xml)
      xml['cac'].Country do
        xml['cbc'].IdentificationCode identification_code
      end
    end
  end
end