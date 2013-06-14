module SUNAT
  
  class TaxScheme
    include Model
    
    property :id,               String # id of the tax in sunat's catalog
    property :name,             String # name of the tax
    property :tax_type_code,    String # TODO: Range in in UN/ECE 5153
  end
  
  class TaxCategory
    include Model
    
    property :tax_exemption_reason_code,  String # TODO: IGV affectation in Catalogue # 07
    property :tier_range,             String # TODO: ISC System in Catalogue # 08
    property :tax_scheme,                 TaxScheme
  end

  class TaxSubTotal
    include Model
    
    property :tax_amount,                 PaymentAmount
    property :tax_category,               TaxCategory
  end
end