# Arosa

[![Gem Version](https://badge.fury.io/rb/arosa.svg)](https://badge.fury.io/rb/arosa) ![Gem Total Downloads](https://img.shields.io/gem/dt/arosa?style=flat&link=https%3A%2F%2Frubygems.org%2Fgems%2Farosa) ![GitHub License](https://img.shields.io/github/license/samuenti/arosa)

Generate [schema.org](https://schema.org) structured data as JSON-LD. Drop it into your pages and let search engines understand your content.

Arosa works anywhere in your Ruby code. Build the schema, then output it in your view.

## Installation

```ruby
gem 'arosa'
```

Then `bundle install`.

## Supported Types

| Type | Schema.org |
|------|------------|
| [Organization](#organization) | [schema.org/Organization](https://schema.org/Organization) |
| [PostalAddress](#postaladdress) | [schema.org/PostalAddress](https://schema.org/PostalAddress) |
| [ContactPoint](#contactpoint) | [schema.org/ContactPoint](https://schema.org/ContactPoint) |
| [BreadcrumbList](#breadcrumblist) | [schema.org/BreadcrumbList](https://schema.org/BreadcrumbList) |
| [ListItem](#listitem) | [schema.org/ListItem](https://schema.org/ListItem) |
| [Language](#language) | [schema.org/Language](https://schema.org/Language) |
| [WebApplication](#webapplication) | [schema.org/WebApplication](https://schema.org/WebApplication) |
| [Article](#article) | [schema.org/Article](https://schema.org/Article) |

More types coming.

---

### Organization

| Property | Type |
|----------|------|
| name | String |
| alternate_name | String |
| description | String |
| url | String |
| logo | String |
| email | String |
| telephone | String |
| address | [PostalAddress](#postaladdress) |
| contact_point | [ContactPoint](#contactpoint) |
| legal_name | String |
| tax_id | String |
| vat_id | String |
| duns | String |
| lei_code | String |
| iso6523_code | String |
| global_location_number | String |
| naics | String |
| founding_date | Date |
| number_of_employees | Integer |
| same_as | Array of String |

```ruby
@organisation = Arosa::Schemas::Organization.new(
  name: "Acme Corp",
  url: "https://acme.com",
  logo: "https://acme.com/logo.png",
  email: "hello@acme.com",
  founding_date: Date.new(2020, 1, 1),
  same_as: [
    "https://linkedin.com/company/acme",
    "https://en.wikipedia.org/wiki/Acme"
  ],
  address: Arosa::Schemas::PostalAddress.new(
    street_address: "123 Main St",
    address_locality: "Zug",
    address_country: "CH",
    postal_code: "6300"
  ),
  contact_point: Arosa::Schemas::ContactPoint.new(
    contact_type: "customer service",
    telephone: "+1-800-555-1234",
    email: "support@acme.com"
  )
)
```

In your view:

```erb
<%= @organisation %>
```

Output:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Acme Corp",
  "url": "https://acme.com",
  "logo": "https://acme.com/logo.png",
  "email": "hello@acme.com",
  "foundingDate": "2020-01-01",
  "sameAs": ["https://linkedin.com/company/acme", "https://en.wikipedia.org/wiki/Acme"],
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main St",
    "addressLocality": "Zug",
    "addressCountry": "CH",
    "postalCode": "6300"
  },
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "customer service",
    "telephone": "+1-800-555-1234",
    "email": "support@acme.com"
  }
}
</script>
```

The same pattern applies to all schema types.

### PostalAddress

| Property | Type |
|----------|------|
| street_address | String |
| address_locality | String |
| address_region | String |
| postal_code | String |
| address_country | String |

```ruby
Arosa::Schemas::PostalAddress.new(
  street_address: "123 Main St",
  address_locality: "Zug",
  address_region: "ZG",
  address_country: "CH",
  postal_code: "6300"
)
```

### ContactPoint

| Property | Type |
|----------|------|
| contact_type | String |
| telephone | String |
| email | String |
| available_language | Array of String or [Language](#language) |

```ruby
# Simple: just language codes
Arosa::Schemas::ContactPoint.new(
  contact_type: "customer service",
  telephone: "+1-800-555-1234",
  available_language: ["en", "es"]
)

# Detailed: full Language objects
Arosa::Schemas::ContactPoint.new(
  contact_type: "customer service",
  telephone: "+1-800-555-1234",
  available_language: [
    Arosa::Schemas::Language.new(name: "English", alternate_name: "en"),
    Arosa::Schemas::Language.new(name: "Spanish", alternate_name: "es")
  ]
)
```

### BreadcrumbList

| Property | Type |
|----------|------|
| item_list_element | Array of [ListItem](#listitem) |

```ruby
Arosa::Schemas::BreadcrumbList.new(
  item_list_element: [
    Arosa::Schemas::ListItem.new(position: 1, name: "Home", item: "https://example.com"),
    Arosa::Schemas::ListItem.new(position: 2, name: "Books", item: "https://example.com/books"),
    Arosa::Schemas::ListItem.new(position: 3, name: "Science Fiction")
  ]
)
```

### ListItem

| Property | Type |
|----------|------|
| position | Integer |
| name | String |
| item | String |

```ruby
Arosa::Schemas::ListItem.new(
  position: 1,
  name: "Books",
  item: "https://example.com/books"
)
```

Note: `item` is optional on the last breadcrumb (the current page).

### Language

| Property | Type |
|----------|------|
| name | String |
| alternate_name | String |

```ruby
Arosa::Schemas::Language.new(
  name: "Spanish",
  alternate_name: "es"
)
```

### WebApplication

| Property | Type |
|----------|------|
| name | String |
| description | String |
| url | String |
| image | String |
| application_category | String |
| application_sub_category | String |
| browser_requirements | String |
| operating_system | String |
| software_version | String |
| download_url | String |
| install_url | String |
| screenshot | Array of String |
| feature_list | Array of String |
| release_notes | String |
| permissions | String |
| software_requirements | String |
| same_as | Array of String |

```ruby
Arosa::Schemas::WebApplication.new(
  name: "Acme Task Manager",
  description: "A web-based task management application",
  url: "https://tasks.acme.com",
  application_category: "BusinessApplication",
  browser_requirements: "Requires JavaScript and HTML5 support",
  software_version: "2.1.0",
  feature_list: [
    "Real-time collaboration",
    "Calendar integration",
    "Mobile-friendly interface"
  ],
  screenshot: [
    "https://tasks.acme.com/screenshots/dashboard.png",
    "https://tasks.acme.com/screenshots/calendar.png"
  ]
)
```

### Article

| Property | Type |
|----------|------|
| name | String |
| url | String |
| image | String |
| same_as | Array of String |
| headline | String |
| alternative_headline | String |
| description | String |
| author | String |
| publisher | String |
| date_published | Date |
| date_modified | Date |
| date_created | Date |
| keywords | String |
| in_language | String |
| thumbnail_url | String |
| abstract | String |
| comment_count | Integer |
| copyright_holder | String |
| copyright_year | Integer |
| editor | String |
| genre | String |
| is_accessible_for_free | Boolean |
| license | String |
| article_section | String |
| word_count | Integer |

```ruby
Arosa::Schemas::Article.new(
  headline: "How to Tie a Reef Knot",
  author: "John Doe",
  date_published: Date.new(2026, 2, 26),
  description: "A step-by-step guide to tying the classic reef knot.",
  article_section: "Outdoors",
  word_count: 1200,
  image: "https://example.com/images/reef-knot.jpg",
  keywords: "knots, sailing, outdoors",
  in_language: "en",
  is_accessible_for_free: true
)
```

## Validation

Wrong types and unknown properties raise errors immediately:

```ruby
Arosa::Schemas::Organization.new(name: 123)
# => ArgumentError: name must be a String, got Integer

Arosa::Schemas::Organization.new(made_up: "value")
# => NoMethodError: undefined method `made_up='
```

No silent failures. If it builds, the markup is valid.

## License

MIT
