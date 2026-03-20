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
      merged[:_defaults] = defaults
      noindex = merged[:noindex]
      tags = []

      tags << charset_tag(merged[:charset] || "utf-8")
      tags << title_tag(merged)
      tags << description_tag(merged[:description])
      tags << canonical_tag(merged, request: request, noindex: noindex)
      tags << robots_tag(merged)
      tags.concat(hreflang_tags(merged, request: request))

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

    def hreflang_tags(merged, request: nil)
      defaults = merged[:_defaults] || {}
      page_value = @data[:hreflang]
      default_locales = defaults[:hreflang]
      opt_in = merged[:hreflang_opt_in]

      return [] if page_value == false
      return [] unless default_locales.is_a?(Array)

      if opt_in
        return [] unless page_value
      end

      locales = page_value.is_a?(Array) ? page_value : default_locales
      return [] if locales.empty?
      return [] unless request

      pattern = merged[:hreflang_pattern]
      fullpath = request.fullpath
      origin = "#{request.scheme}://#{request.host}"

      x_default = merged[:hreflang_default] || default_locales&.first

      tags = locales.map do |locale|
        href = build_hreflang_href(locale, pattern, fullpath, origin)
        %(<link rel="alternate" hreflang="#{escape(locale)}" href="#{escape(href)}">)
      end

      if x_default
        href = build_hreflang_href(x_default, pattern, fullpath, origin)
        tags << %(<link rel="alternate" hreflang="x-default" href="#{escape(href)}">)
      end

      tags
    end

    def build_hreflang_href(locale, pattern, fullpath, origin)
      if pattern
        pattern.gsub(":locale", locale.to_s).gsub(":path", fullpath)
      else
        "#{origin}/#{locale}#{fullpath}"
      end
    end

    def escape(value)
      value.to_s.gsub("&", "&amp;").gsub('"', "&quot;").gsub("<", "&lt;").gsub(">", "&gt;")
    end
  end
end
