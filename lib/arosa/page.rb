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
      tags.concat(schema_tags(@meta.data[:schema], context: @defaults[:schemas] || {}))

      html = tags.compact.join("\n")
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

    private

    def schema_tags(schema, context: {})
      return [] unless schema

      schemas = schema.is_a?(Array) ? schema : [schema]
      schemas.map do |s|
        s = Arosa::Schema.build(s, context: context) if s.is_a?(Hash) || s.is_a?(Symbol)
        s.to_html
      end
    end
  end
end
