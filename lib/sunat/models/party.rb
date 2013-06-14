module SUNAT
  
  class PartyName
    include Model
    
    property :name, String
  end
  
  class Party
    include Model
    
    property :name,                   String
    property :party_name,             PartyName
    property :physical_location,      PhysicalLocation
    property :party_legal_entities,   [PartyLegalEntity]
    property :postal_addresses,       [PostalAddress]
    
    validates :party_legal_entities, existence: true, not_empty: true
    validates :postal_addresses, existence: true, not_empty: true
    
    def initialize
      self.party_legal_entities = []
    end
  end
end