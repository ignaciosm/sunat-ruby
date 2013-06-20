module SUNAT
  class PhysicalLocation
    include Model
    
    property :description, String
    
    def build_xml(xml)
      xml['cac'].PhysicalLocation do
        xml['cbc'].Description description
      end
    end
  end
end