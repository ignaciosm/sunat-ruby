module SUNAT
  module Properties
    extend ActiveSupport::Concern

    def get_attribute(name)
      self[name]
    end

    def set_attribute(name, value)
      property = get_property(name)
      if property.nil?
        self[name.to_sym] = value
      else
        self[property.name] = value.present? ?  property.cast(self, value) : value
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
    
    private
    
    def get_property(name)
      self.class.properties[name.to_sym]
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
        
        # Build method
        # Instantiates the object based on the property
        # set its value and attach it to a block
        # 
        # Usage:
        # 
        # class Profile
        #   property :name, String
        # end
        # 
        # class User
        #   property :profile, Profile
        # end
        # 
        # user = User.new
        # user.build_profile do |profile|
        #   profile.name = "Profile Name"
        # end
        # 
        if property.type.respond_to?(:new)
          define_method "build_#{property.name}" do |*args, &block|
            value = property.type.new(*args)
            set_attribute(property.name, value)
            block.call(value)
            value
          end
        end
      end

    end


  end
end
