module SUNAT
  
  class DocumentReference
    include Model
    
    property :document_type_code, String # TODO: Range in Catalog # 01
    property :id,                 String
  end
end