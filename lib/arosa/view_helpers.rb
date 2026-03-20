# frozen_string_literal: true

module Arosa
  module ViewHelpers
    def set_arosa(**attrs)
      arosa_page.set(**attrs)
    end

    def arosa_tags(**defaults)
      req = respond_to?(:request) ? request : nil
      arosa_page.render(request: req, **defaults)
    end

    private

    def arosa_page
      @arosa_page ||= Arosa::Page.new
    end
  end
end
