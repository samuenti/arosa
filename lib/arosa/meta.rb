# frozen_string_literal: true

module Arosa
  class Meta
    ROBOT_DIRECTIVES = %i[noindex nofollow noarchive index follow].freeze

    attr_reader :data

    def initialize
      @data = {}
    end

    def set(**attrs)
      @data.merge!(attrs)
    end

    def render(request: nil, **defaults)
      merged = defaults.merge(@data)
      noindex = merged[:noindex]
      tags = []

      tags << charset_tag(merged[:charset] || "utf-8")
      tags << title_tag(merged)
      tags << description_tag(merged[:description])
      tags << canonical_tag(merged, request: request, noindex: noindex)
      tags << robots_tag(merged)

      html = tags.compact.join("\n")
      html.respond_to?(:html_safe) ? html.html_safe : html
    end

    private

    def charset_tag(charset)
      %(<meta charset="#{charset}">)
    end

    def title_tag(merged)
      page_title = merged[:title]
      site = merged[:site]
      separator = " #{merged[:separator] || '|'} "
      reverse = merged[:reverse]

      parts = [page_title, site].compact
      parts.reverse! if reverse

      return if parts.empty?

      %(<title>#{escape(parts.join(separator))}</title>)
    end

    def description_tag(description)
      return unless description

      %(<meta name="description" content="#{escape(description)}">)
    end

    def canonical_tag(merged, request: nil, noindex: false)
      canonical = merged[:canonical]
      canonical ||= request&.url if merged[:auto_canonical] && !noindex
      return unless canonical

      %(<link rel="canonical" href="#{escape(canonical)}">)
    end

    def robots_tag(merged)
      directives = ROBOT_DIRECTIVES.select { |d| merged[d] }
      return if directives.empty?

      %(<meta name="robots" content="#{directives.join(", ")}">)
    end

    def escape(value)
      value.to_s.gsub("&", "&amp;").gsub('"', "&quot;").gsub("<", "&lt;").gsub(">", "&gt;")
    end
  end
end
