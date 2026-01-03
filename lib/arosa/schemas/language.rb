# frozen_string_literal: true

module Arosa
  module Schemas
    # Schema.org Language type
    #
    # https://schema.org/Language
    class Language < Schema
      schema_type "Language"

      property :name, type: String
      property :alternate_name, type: String
    end
  end
end
