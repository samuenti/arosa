# frozen_string_literal: true

require "date"
require "json"
require_relative "arosa/version"
require_relative "arosa/schema"

# Schemas
require_relative "arosa/schemas/postal_address"
require_relative "arosa/schemas/contact_point"
require_relative "arosa/schemas/organization"

module Arosa
  class Error < StandardError; end
end
