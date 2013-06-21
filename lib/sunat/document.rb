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
    
    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end
    
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
    
    protected
    
    def to_xml(root_name, &block)
      # Auto-decorate
      xml_document = XMLDocument.new(self)
      xml_document.build_basic_xml do |xml|
        block.call(xml) if block.present?
      end
    end
  end
end