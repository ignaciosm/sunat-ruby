module SUNAT
  
  class DocumentReference
    include Model
    
    property :document_type_code, String
    property :id,                 String
    
    validates :document_type_code, tax_document_type_code: true
  end
end