module SUNAT
  class TaxScheme
    include Model
    
    property :id,               String # id of the tax in sunat's catalog
    property :name,             String # name of the tax
    property :tax_type_code,    String
    
    validates :tax_type_code, tax_type_code: true
    
    def build_xml(xml)
      xml['cac'].TaxScheme do
        xml['cbc'].ID           id
        xml['cbc'].Name         name
        xml['cbc'].TaxTypeCode  tax_type_code
      end
    end
  end
end