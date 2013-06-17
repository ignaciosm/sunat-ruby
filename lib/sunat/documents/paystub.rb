module SUNAT
  #
  # The paystub is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Boleta
  #
  
  class Paystub < Document
    extend PaymentDocument
    
    # All the paystub structure is identical
    # to the invoice's one. All the structure
    # is inherited from PaymentDocument
    
    def to_xml
      
    end
  end
end
