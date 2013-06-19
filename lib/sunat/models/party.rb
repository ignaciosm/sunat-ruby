module SUNAT
  
  class PhysicalLocation
    include Model
    
    property :description, String
  end
  
  class Party
    include Model
    
    property :name,                   String
    property :physical_location,      PhysicalLocation # only for tacna and only for receipts
    property :party_legal_entities,   [PartyLegalEntity]
    property :postal_addresses,       [PostalAddress]
    
    validates :party_legal_entities, existence: true, not_empty: true
    validates :postal_addresses, existence: true, not_empty: true
    
    def initialize
      self.party_legal_entities = []
      self.postal_addresses = []
    end
  end
end