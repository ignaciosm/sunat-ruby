module SUNAT
  class PostalAddress
    include Model
    
    property :id,                     String # ubigeo
    property :street_name,            String # full address
    property :city_subdivision_name,  String # urbanization or zone
    property :city_name,              String # department
    property :country_subentity,      String # province
    property :district,               String # district
    property :country,                Country
  end
end