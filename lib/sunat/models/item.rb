module SUNAT
  
  class SellersItemIdentification
    include Model
    
    property :id, String # product code
  end
  
  class Item
    include Model
    
    property :description,                  String
    property :sellers_item_identification,  [SellersItemIdentification]
  end
end