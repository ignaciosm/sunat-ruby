module SUNAT
  class TaxScheme
    include Model
    
    property :id,               String # id of the tax in sunat's catalog
    property :name,             String # name of the tax
    property :tax_type_code,    String
    
    validates :tax_type_code, tax_type_code: true
    
    TAX_TABLE = [
      { id: "1000", name: "IGV", tax_type_code: "VAT" },
      { id: "2000", name: "ISC", tax_type_code: "EXC" }
    ]
    
    OTHER_TAX = { id: "9999", name: "OTROS", tax_type_code: "OTH" }
    
    def build_xml(xml)
      xml['cac'].TaxScheme do
        xml['cbc'].ID           id
        xml['cbc'].Name         name
        xml['cbc'].TaxTypeCode  tax_type_code
      end
    end
    
    def self.build_for(name)
      normalized_name = name.to_s.downcase
      
      tax_data = TAX_TABLE.find do |tax_row|
        tax_row[:name].downcase == normalized_name
      end
      
      self.new(tax_data || OTHER_TAX)
    end
  end
end