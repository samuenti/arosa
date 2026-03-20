# frozen_string_literal: true

module Arosa
  class Page
    def initialize
      @meta = Meta.new
      @defaults = {}
    end

    def defaults(**attrs)
      @defaults.merge!(attrs)
    end

    def set(**attrs)
      @meta.set(**attrs)
    end

    def render(request: nil)
      config = Arosa.config.to_h
      combined = config.merge(@defaults)
      merged = combined.merge(@meta.data)
      tags = []

      tags << @meta.render(request: request, **combined)
      tags << schema_tag(merged[:schema], context: @defaults[:schemas] || {})

      tags.compact.join("\n")
    end

    private

    def schema_tag(schema, context: {})
      return unless schema

      schema = Arosa::Schema.build(schema, context: context) if schema.is_a?(Hash) || schema.is_a?(Symbol)
      schema.to_html
    end
  end
end
