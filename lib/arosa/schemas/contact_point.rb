# frozen_string_literal: true

module Arosa
  module Schemas
    class ContactPoint < Schema
      schema_type "ContactPoint"

      property :contact_type, type: String
      property :telephone, type: String
      property :email, type: String
    end
  end
end
