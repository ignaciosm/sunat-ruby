module SUNAT
  module Properties
    extend ActiveSupport::Concern

    def get_attribute(name)
      self[name]
    end

    def set_attribute(name, value)
      property = self.class.properties[name.to_sym]
      if property.nil?
        self[name.to_sym] = value
      else
        self[property.name] = property.cast(self, value)
      end
    end

    protected

    # Internal method to go through each attribute and set the
    # values via the set_attribute method.
    def set_attributes(attrs = {})
      attrs.each do |key, value|
        set_attribute(key, value)
      end
    end

    module ClassMethods

      attr_accessor :properties

      def property(*args)
        self.properties ||= {}

        # Prepare the property object and methods
        property = Property.new(*args)
        properties[property.name] = property
        define_property_methods(property)

        property
      end


      protected

      def define_property_methods(property)
        # Getter
        define_method(property.name) do
          get_attribute(property.name)
        end
        # Setter
        define_method "#{property.name}=" do |value|
          set_attribute(property.name, value)
        end
      end

    end


  end
end
