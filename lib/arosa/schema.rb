# frozen_string_literal: true

module Arosa
  class Schema
    class << self
      def properties
        @properties ||= {}
      end

      def property(name, required: false, type: nil)
        properties[name] = { required: required, type: type }

        define_method(name) do
          @values[name]
        end

        define_method("#{name}=") do |value|
          validate_type!(name, value, type) if type && !value.nil?
          @values[name] = value
        end
      end

      def schema_type(type = nil)
        if type
          @schema_type = type
        else
          @schema_type || name.split("::").last
        end
      end

      def inherited(subclass)
        super
        subclass.instance_variable_set(:@properties, properties.dup)
      end
    end

    def initialize(**attrs)
      @values = {}
      attrs.each { |key, value| send("#{key}=", value) }
      raise ArgumentError, "Missing required: #{missing_required.join(", ")}" if missing_required.any?
    end

    def valid?
      missing_required.empty?
    end

    def missing_required
      self.class.properties.select { |_, opts| opts[:required] }.keys.reject { |name| @values[name] }
    end

    def to_h(nested: false)
      data = nested ? {} : { "@context" => "https://schema.org" }
      data["@type"] = self.class.schema_type

      @values.each do |key, value|
        data[camelize(key)] = serialize_value(value)
      end

      data.compact
    end

    def to_json(*_args)
      JSON.generate(to_h)
    end

    def to_html
      %(<script type="application/ld+json">#{to_json}</script>)
    end

    alias to_s to_html

    private

    def validate_type!(name, value, type)
      return if type.is_a?(Array) && value.is_a?(Array) && value.all? { |v| v.is_a?(type.first) }
      return if value.is_a?(type)

      raise ArgumentError, "#{name} must be a #{type}, got #{value.class}"
    end

    def camelize(key)
      str = key.to_s
      str.gsub(/_([a-z])/) { ::Regexp.last_match(1).upcase }
    end

    def serialize_value(value)
      case value
      when Schema then value.to_h(nested: true)
      when Array then value.map { |v| serialize_value(v) }
      when Date, Time, DateTime then value.iso8601
      else value
      end
    end
  end
end
