module SUNAT

  class TaxSubTotal
    include Model
    
    property :tax_amount,                 PaymentAmount
    property :tax_category,               String # id of the tax in sunat's catalog
    property :tax_name,                   String # name of the tax
    property :tax_type_code,              String # TODO: Range in in UN/ECE 5153
    property :tax_exemption_reason_code,  String # TODO: IGV affectation in Catalogue # 07
    property :tax_tier_range,             String # TODO: ISC System in Catalogue # 08
  end
end