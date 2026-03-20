# Arosa

[![Gem Version](https://badge.fury.io/rb/arosa.svg)](https://badge.fury.io/rb/arosa) ![Gem Total Downloads](https://img.shields.io/gem/dt/arosa?style=flat&link=https%3A%2F%2Frubygems.org%2Fgems%2Farosa) ![GitHub License](https://img.shields.io/github/license/samuenti/arosa)

Meta tags and structured data for Rails. Drop it in and go.

Arosa works out of the box with Rails. Set your tags in a controller or view, render them in your layout.

## Installation

```ruby
gem 'arosa'
```

Then `bundle install`.

Add `arosa_tags` to your layout. This is required, it renders all your meta tags.

```erb
<head>
  <%= arosa_tags site: "My Website" %>
</head>
```

## Meta Tags

Set meta tags anywhere, controllers or views.

### In a controller

```ruby
class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
    set_arosa title: @article.title, description: @article.excerpt
  end
end
```

### In a view

```erb
<% set_arosa title: @article.title, description: @article.excerpt %>
```

### In your layout

```erb
<head>
  <%= arosa_tags site: "My Website" %>
</head>
```

Output:

```html
<head>
  <meta charset="utf-8">
  <title>Arosa to Lenzerheide: The Complete Trail Guide | My Website</title>
  <meta name="description" content="Everything you need to know about the trail from Arosa to Lenzerheide.">
</head>
```

### Options

| Option | Description |
|--------|-------------|
| `title` | Page title |
| `description` | Page description |
| `site` | Site name, appended to the title |
| `separator` | Text between page title and site name. Default: `\|` |
| `reverse` | When `true`, site name comes first |
| `canonical` | Canonical URL for the page |
| `auto_canonical` | When `true`, uses the current request URL as canonical |
| `charset` | Character set. Default: `utf-8` |
| `noindex` | Tells search engines not to index the page |
| `nofollow` | Tells search engines not to follow links |
| `noarchive` | Tells search engines not to cache the page |
| `index` | Explicitly allow indexing |
| `follow` | Explicitly allow link following |
| `hreflang` | Array of locale codes for alternate language tags |
| `hreflang_opt_in` | When `true`, pages must opt in to hreflang with `set_arosa hreflang: true` |
| `hreflang_default` | Locale to use for `x-default`. Defaults to first in the `hreflang` array |
| `hreflang_pattern` | Custom URL pattern. Use `:locale` and `:path` as placeholders |

### Defaults

Options passed to `arosa_tags` in the layout act as defaults. Page-level values from `set_arosa` override them.

```erb
<%= arosa_tags site: "My Website", description: "Default description for pages that don't set one." %>
```

### Canonical

Set it explicitly:

```ruby
set_arosa canonical: "https://example.com/articles/1"
```

Or auto-generate from the current request URL:

```erb
<%= arosa_tags auto_canonical: true %>
```

Auto-canonical is skipped when `noindex` is set. Manually set canonicals always render.

### Robots

```ruby
set_arosa noindex: true, nofollow: true
```

Output:

```html
<meta name="robots" content="noindex, nofollow">
```

### Hreflang

Add alternate language tags for multilingual pages. Define your locales in the layout:

```erb
<%= arosa_tags hreflang: ["en", "de", "fr", "it"] %>
```

Output (on `https://example.com/articles/1`):

```html
<link rel="alternate" hreflang="en" href="https://example.com/en/articles/1">
<link rel="alternate" hreflang="de" href="https://example.com/de/articles/1">
<link rel="alternate" hreflang="fr" href="https://example.com/fr/articles/1">
<link rel="alternate" hreflang="it" href="https://example.com/it/articles/1">
<link rel="alternate" hreflang="x-default" href="https://example.com/en/articles/1">
```

An `x-default` tag is automatically included, pointing to the first locale in the array. To use a different default:

```erb
<%= arosa_tags hreflang: ["en", "de", "fr", "it"], hreflang_default: "de" %>
```

By default, URLs are built as `/:locale/path`. For other structures, use a pattern:

```erb
<%= arosa_tags hreflang: ["en", "de", "fr", "it"], hreflang_pattern: "https://:locale.example.com:path" %>
```

URL parameters are also supported but [not recommended by Google](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites):

```erb
<%= arosa_tags hreflang: ["en", "de", "fr", "it"], hreflang_pattern: "https://example.com:path?loc=:locale" %>
```

To require pages to opt in instead of enabling globally:

```erb
<%= arosa_tags hreflang: ["en", "de", "fr", "it"], hreflang_opt_in: true %>
```

Then in a view or controller:

```ruby
set_arosa hreflang: true
```

Pages can also narrow the locales or disable entirely:

```ruby
set_arosa hreflang: ["de"]
set_arosa hreflang: false
```

### Multiple calls

`set_arosa` merges. Call it as many times as you want:

```ruby
set_arosa title: "My Page"
set_arosa description: "About this page"
set_arosa noindex: true
```

## Schemas

Generate [schema.org](https://schema.org) structured data as JSON-LD. Build the schema, then output it in your view.

### Supported Types

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
Arosa::Schemas::ContactPoint.new(
  contact_type: "customer service",
  telephone: "+1-800-555-1234",
  available_language: ["en", "es"]
)

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
  headline: "Arosa to Lenzerheide: The Complete Trail Guide",
  author: "John Doe",
  date_published: Date.new(2026, 2, 26),
  description: "Everything you need to know about the trail from Arosa to Lenzerheide.",
  article_section: "Hiking",
  word_count: 1200,
  image: "https://example.com/images/arosa-lenzerheide.jpg",
  keywords: "hiking, alps, arosa, lenzerheide",
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
