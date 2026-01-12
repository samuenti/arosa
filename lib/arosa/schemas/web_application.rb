# frozen_string_literal: true

module Arosa
  module Schemas
    # Schema.org WebApplication type
    #
    # https://schema.org/WebApplication
    class WebApplication < Schema
      schema_type "WebApplication"

      property :name, type: String
      property :description, type: String
      property :url, type: String
      property :image, type: String
      property :application_category, type: String
      property :application_sub_category, type: String
      property :browser_requirements, type: String
      property :operating_system, type: String
      property :software_version, type: String
      property :download_url, type: String
      property :install_url, type: String
      property :screenshot, type: [String]
      property :feature_list, type: [String]
      property :release_notes, type: String
      property :permissions, type: String
      property :software_requirements, type: String
      property :same_as, type: [String]
    end
  end
end
