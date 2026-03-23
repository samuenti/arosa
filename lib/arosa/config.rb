# frozen_string_literal: true

module Arosa
  class Config
    attr_accessor :separator, :hreflang, :hreflang_pattern,
                  :hreflang_opt_in, :hreflang_default, :hreflang_prefix_default,
                  :auto_canonical, :auto_og, :auto_twitter, :twitter_site

    def to_h
      h = {}
      h[:separator] = separator if separator
      h[:hreflang] = hreflang if hreflang
      h[:hreflang_pattern] = hreflang_pattern if hreflang_pattern
      h[:hreflang_opt_in] = hreflang_opt_in unless hreflang_opt_in.nil?
      h[:hreflang_default] = hreflang_default if hreflang_default
      h[:hreflang_prefix_default] = hreflang_prefix_default unless hreflang_prefix_default.nil?
      h[:auto_canonical] = auto_canonical unless auto_canonical.nil?
      h[:auto_og] = auto_og unless auto_og.nil?
      h[:auto_twitter] = auto_twitter unless auto_twitter.nil?
      h[:twitter_site] = twitter_site if twitter_site
      h
    end
  end

  def self.config
    @config ||= Config.new
  end
end
