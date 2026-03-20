# frozen_string_literal: true

module Arosa
  module ViewHelpers
    def set_arosa(**attrs)
      arosa_meta.set(**attrs)
    end

    def arosa_tags(**defaults)
      req = respond_to?(:request) ? request : nil
      arosa_meta.render(request: req, **defaults)
    end

    private

    def arosa_meta
      @arosa_meta ||= Arosa::Meta.new
    end
  end
end
