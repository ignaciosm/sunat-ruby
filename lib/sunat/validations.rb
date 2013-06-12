module SUNAT

  # Use ActiveModel Validations so that complex models can be
  # validated before generating a declaration document.
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    # Determine if the model is valid.
    #
    # SUNAT Models are not designed for perisistance, so the context
    # is always assumed to be "create".
    def valid?(*args)
      super(:create)
    end

    module ClassMethods
      # Here we should add support for validating casted models
    end

  end
end

# Add custom validators here to allow it to be used from any model
# allowing everty validator which extends from EachValidator
# to be used with the validates method.
# 
# validates :field, existence: true #=> ExistenceValidator
# 
module ActiveModel
  module Validations
    # Tests nil. The default PresenceValidator only tests string emptyness.
    class ExistenceValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add attribute, (options[:message] || "is nil.") if value.nil?
      end
    end
  end
end