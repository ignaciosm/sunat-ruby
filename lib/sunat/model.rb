module SUNAT

  # The sunat Model module is included into a model to allow support for serialization,
  # validation, and simple typecasting.
  module Model
    extend ActiveSupport::Concern

    include ActiveModel::Validations

    included do
      include Castable
      include Attributes
      include Properties
      include Validations
    end

    def initialize(attrs = {})
      # Use the `Properties` module's `#set_attribtues` method
      set_attributes(attrs)
    end

    module ClassMethods
      # Little help. Equivalent to new.tap
      def build(*attrs)
        instance = self.new(*attrs)
        yield instance if block_given?
        instance
      end
    end

  end

end
