# frozen_string_literal: true

module Arosa
  module Schemas
    class Organization < Schema
      schema_type "Organization"

      property :name, type: String
      property :alternate_name, type: String
      property :description, type: String
      property :url, type: String
      property :logo, type: String
      property :email, type: String
      property :telephone, type: String
      property :address, type: PostalAddress
      property :contact_point, type: ContactPoint
      property :legal_name, type: String
      property :tax_id, type: String
      property :vat_id, type: String
      property :duns, type: String
      property :lei_code, type: String
      property :iso6523_code, type: String
      property :global_location_number, type: String
      property :naics, type: String
      property :founding_date, type: Date
      property :number_of_employees
      property :same_as, type: [String]
    end
  end
end
