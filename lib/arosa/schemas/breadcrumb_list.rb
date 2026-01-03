# frozen_string_literal: true

module Arosa
  module Schemas
    # Schema.org BreadcrumbList type
    #
    # https://schema.org/BreadcrumbList
    class BreadcrumbList < Schema
      schema_type "BreadcrumbList"

      property :item_list_element, type: [ListItem]
    end
  end
end
