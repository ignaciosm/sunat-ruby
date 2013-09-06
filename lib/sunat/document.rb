# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model

    DEFAULT_CUSTOMIZATION_ID = "1.0"

    property :id,                    String # Usually: serial + correlative number
    property :issue_date,            Date
    property :customization_id,      String
    property :supplier,              AccountingSupplierParty
    property :additional_properties, [AdditionalProperty]


    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end

    def initialize(*args)
      super(*args)
      self.issue_date ||= Date.today
      self.additional_properties ||= []
    end

    def supplier
      read_attribute(:supplier) || AccountingSupplierParty.new(SUNAT::SUPPLIER)
    end

    def file_name
      raise "should be implemented in the real document"
    end

    def operation_list
      raise "should be implemented in the real document"
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

    # The signature here is for two reasons:
    #   1. easy call of the global SUNAT::SIGNATURE
    #   2. possible dependency injection of a signature in a test vía stubs
    #
    attr_accessor :signature

    def signature
      @signature ||= SUNAT::SIGNATURE
    end

    def to_xml(&block)
      # We create a decorator responsible to build the xml in top
      # of this document
      xml_document = XMLDocument.new(self)
      xml = xml_document.build_xml(&block)
      
      # We pass a decorator to xml_signer, to allow it to use some generators
      # of xml_document
      xml_signer = XMLSigner.new(xml_document)
      xml_signer.sign(xml)

      # Pass control over to the xml builder
      build_xml(xml)
    end

    def build_xml(xml)
      raise "This method must be overriden!"
    end

    # returns a savon response (an httpi response)
    def deliver!
      sender = Delivery::Sender.new(file_name, to_zip, operation)
      sender.call
    end

    def to_zip
      @zip ||= Delivery::Chef.new(file_name + ".xml", to_xml).prepare
    end
  end
end
