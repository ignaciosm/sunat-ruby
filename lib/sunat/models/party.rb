module SUNAT
  
  class Party
    include Model
    
    property :name,                   String
    property :physical_location,      PhysicalLocation
    property :party_legal_entities,   [PartyLegalEntity]
    property :postal_addresses,       [PostalAddress]
    
    validates :party_legal_entities, existence: true, not_empty: true
    validates :postal_addresses, existence: true, not_empty: true
  end
end