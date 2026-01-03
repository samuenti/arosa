# frozen_string_literal: true

module Arosa
  module Schemas
    # Schema.org ListItem type
    #
    # https://schema.org/ListItem
    class ListItem < Schema
      schema_type "ListItem"

      property :position, type: Integer
      property :name, type: String
      property :item, type: String
    end
  end
end
