# frozen_string_literal: true

module Arosa
  module Schemas
    # Schema.org Article type
    #
    # https://schema.org/Article
    class Article < Schema
      schema_type "Article"

      property :name, type: String
      property :url, type: String
      property :image, type: String
      property :same_as, type: [String]
      property :headline, type: String
      property :alternative_headline, type: String
      property :description, type: String
      property :author, type: String
      property :publisher, type: String
      property :date_published, type: Date
      property :date_modified, type: Date
      property :date_created, type: Date
      property :keywords, type: String
      property :in_language, type: String
      property :thumbnail_url, type: String
      property :abstract, type: String
      property :comment_count, type: Integer
      property :copyright_holder, type: String
      property :copyright_year, type: Integer
      property :editor, type: String
      property :genre, type: String
      property :is_accessible_for_free
      property :license, type: String
      property :article_section, type: String
      property :word_count, type: Integer
    end
  end
end
