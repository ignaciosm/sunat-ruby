module SUNAT
  
  class Item
    include Model
    
    property :description,                  String
    property :id,                           String #product code
    
    def build_xml(xml)
      xml['cac'].Item do
        xml['cbc'].Description description
        if id.present?
          xml['cac'].SellersItemIdentification do
            xml['cbc'].ID id
          end
        end
      end
    end
  end
end
