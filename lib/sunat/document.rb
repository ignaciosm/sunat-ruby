# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model
    
    DEFAULT_CUSTOMIZATION_ID = "1.0"
    
    property :issue_date,                 Date
    property :customization_id,           String
    property :additional_monetary_totals, [MonetaryTotal]
    property :additional_properties,      [AdditionalProperty]
    
    def initialize
      super
      self.issue_date = Date.today
      self.additional_properties = []
      self.additional_monetary_totals = []
    end
    
    def customization_id
      self['customization_id'] ||= DEFAULT_CUSTOMIZATION_ID
    end
    
    def add_additional_property(options)
      id = options[:id]
      name = options[:name]
      value = options[:value]
      
      self.additional_properties << AdditionalProperty.new.tap do |property|
        property.id = id        if id
        property.name = name    if name
        property.value = value  if value
      end
    end
  end
end