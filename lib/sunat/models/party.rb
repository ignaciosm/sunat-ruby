module SUNAT
  
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
    
    def build_xml(xml)
      xml['cac'].Party do
        if name.present?
          xml['cac'].PartyName do
            xml['cbc'].Name name
          end
        end
        
        postal_addresses.each do |address|
          address.build_xml xml
        end
        
        party_legal_entities.each do |entity|
          entity.build_xml xml
        end
        
        if physical_location.present?
          physical_location.build_xml xml
        end
      end
    end
  end
end