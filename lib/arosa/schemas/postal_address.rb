# frozen_string_literal: true

module Arosa
  module Schemas
    class PostalAddress < Schema
      schema_type "PostalAddress"

      property :street_address, type: String
      property :address_locality, type: String
      property :address_region, type: String
      property :postal_code, type: String
      property :address_country, type: String
    end
  end
end
