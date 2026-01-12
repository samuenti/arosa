# frozen_string_literal: true

require "date"
require "json"
require_relative "arosa/version"
require_relative "arosa/schema"

# Schemas
require_relative "arosa/schemas/postal_address"
require_relative "arosa/schemas/language"
require_relative "arosa/schemas/contact_point"
require_relative "arosa/schemas/organization"
require_relative "arosa/schemas/list_item"
require_relative "arosa/schemas/breadcrumb_list"
require_relative "arosa/schemas/web_application"

module Arosa
  class Error < StandardError; end
end
