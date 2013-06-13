module SUNAT
  class DocumentReference
    include Model
    
    property :id,                 String
    
    property :document_type_code, String # TODO: document_type_code range
  end
end