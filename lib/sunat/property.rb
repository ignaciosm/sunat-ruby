module SUNAT
  class Property

    attr_accessor :name, :type

    def initialize(name, type)
      self.name = name.to_sym
      self.type = type
    end

    def to_s
      name.to_s
    end

    def to_sym
      name
    end

    def cast(owner, value)
      if type.is_a?(Array)
        CastedArray.new(owner, self, value)
      else
        build(owner, value)
      end
    end

    def build(owner, value)
      obj = nil
      if value.is_a?(type)
        obj = value
      else
        obj = type.new(value)
      end
      obj.casted_by = owner if obj.respond_to?(:casted_by=)
      obj.casted_by_property = self if obj.respond_to?(:casted_by_property=)
      obj
    end

  end
end
