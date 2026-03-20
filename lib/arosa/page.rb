# frozen_string_literal: true

module Arosa
  class Page
    CONFIG_ONLY_KEYS = %i[separator auto_canonical hreflang hreflang_pattern
                          hreflang_opt_in hreflang_default organization].freeze

    PAGE_ONLY_KEYS = %i[title description canonical charset reverse noindex
                        nofollow noarchive index follow schema hreflang].freeze

    def initialize
      @meta = Meta.new
    end

    def set(**attrs)
      @meta.set(**attrs)
    end

    def render(request: nil, **layout)
      invalid = layout.keys & CONFIG_ONLY_KEYS
      if invalid.any?
        raise ArgumentError, "#{invalid.join(", ")} must be set in config, not in the layout"
      end

      config = Arosa.config.to_h
      defaults = config.merge(layout)
      merged = defaults.merge(@meta.data)
      tags = []

      tags << @meta.render(request: request, **defaults)
      tags << schema_tag(merged[:schema])

      html = tags.compact.join("\n")
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

    private

    def schema_tag(schema)
      return unless schema

      schema = Arosa::Schema.build(schema) if schema.is_a?(Hash) || schema.is_a?(Symbol)
      schema.to_html
    end
  end
end
