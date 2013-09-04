module SUNAT
  #
  # The receipt is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Boleta
  #
  
  class Receipt < Document
    extend PaymentDocument
    
    DOCUMENT_TYPE_CODE = '03' # sunat code in catalog #1

    ID_FORMAT = /B[A-Z\d]{3}-\d{1,8}/
    
  end
end
