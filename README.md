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

## Configuration

Set site-wide defaults in an initializer.

```ruby
# config/initializers/arosa.rb
Arosa.config.separator = "|"
Arosa.config.auto_canonical = true
Arosa.config.hreflang = ["en", "de", "fr", "it"]
Arosa.config.hreflang_pattern = "https://:locale.example.com:path"
Arosa.config.hreflang_opt_in = true
Arosa.config.hreflang_default = "en"
Arosa.config.auto_og = false
Arosa.config.auto_twitter = false

Arosa.config.organization = {
  type: :organization,
  name: "Acme Corp",
  url: "https://acme.com",
  logo: "https://acme.com/logo.png",
  email: "hello@acme.com"
}
```

| Option | Description |
|--------|-------------|
| `separator` | Text between page title and site name. Default: `\|` |
| `auto_canonical` | When `true`, uses the current request URL as canonical |
| `hreflang` | Array of locale codes for alternate language tags |
| `hreflang_pattern` | Custom URL pattern. Use `:locale` and `:path` as placeholders |
| `hreflang_opt_in` | When `true`, pages must opt in to hreflang |
| `hreflang_default` | Locale for `x-default`. Defaults to first in the `hreflang` array |
| `auto_og` | Auto-generate Open Graph tags from title/description. Default: `true` |
| `auto_twitter` | Auto-generate Twitter Card tags from title/description. Default: `true` |
| `organization` | Reusable organization schema hash |

These options can only be set in the config. The layout only accepts `site:`.

The organization can be referenced by name on any page:

```ruby
set_arosa schema: :organization
```

Or as a nested value:

```ruby
set_arosa schema: { type: :article, headline: "My Article", author: :organization }
```

If a page passes a full hash instead, the config is ignored completely.

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
| `reverse` | When `true`, site name comes first |
| `canonical` | Canonical URL for the page |
| `charset` | Character set. Default: `utf-8` |
| `noindex` | Tells search engines not to index the page |
| `nofollow` | Tells search engines not to follow links |
| `noarchive` | Tells search engines not to cache the page |
| `index` | Explicitly allow indexing |
| `follow` | Explicitly allow link following |
| `og` | Open Graph tags (Hash) |
| `twitter` | Twitter Card tags (Hash) |
| `schema` | Schema.org structured data (Hash or Symbol) |

### Defaults

The layout accepts `site:` and `description:` as fallback defaults. Page-level values from `set_arosa` override them.

```erb
<%= arosa_tags site: "My Website", description: "Default description for pages that don't set one." %>
```

### Canonical

Set it explicitly:

```ruby
set_arosa canonical: "https://example.com/articles/1"
```

Or enable `auto_canonical` in the config to use the current request URL automatically.

Auto-canonical is skipped when `noindex` is set. Manually set canonicals always render.

### Robots

```ruby
set_arosa noindex: true, nofollow: true
```

Output:

```html
<meta name="robots" content="noindex, nofollow">
```

### Open Graph

`og:title` and `og:description` are automatically set from `title` and `description`. Override them or add more:

```ruby
set_arosa(
  title: "Arosa to Lenzerheide",
  description: "The complete trail guide.",
  og: { image: "https://example.com/trail.jpg", type: "article" }
)
```

Output:

```html
<meta property="og:title" content="Arosa to Lenzerheide">
<meta property="og:description" content="The complete trail guide.">
<meta property="og:image" content="https://example.com/trail.jpg">
<meta property="og:type" content="article">
```

To use a different title or description for social:

```ruby
set_arosa(
  title: "Arosa to Lenzerheide — Dashboard",
  og: { title: "Arosa to Lenzerheide", description: "Shorter for social" }
)
```

### Twitter Cards

```ruby
set_arosa twitter: { card: "summary_large_image", site: "@acme" }
```

Output:

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@acme">
```

### Hreflang

Configure your locales in the initializer (see [Configuration](#configuration)). Hreflang tags are generated automatically on every page.

Output (on `https://example.com/articles/1`):

```html
<link rel="alternate" hreflang="en" href="https://example.com/en/articles/1">
<link rel="alternate" hreflang="de" href="https://example.com/de/articles/1">
<link rel="alternate" hreflang="fr" href="https://example.com/fr/articles/1">
<link rel="alternate" hreflang="it" href="https://example.com/it/articles/1">
<link rel="alternate" hreflang="x-default" href="https://example.com/en/articles/1">
```

An `x-default` tag is automatically included, pointing to the first locale in the array. Override with `hreflang_default` in the config.

By default, URLs are built as `/:locale/path`. For other structures, set `hreflang_pattern` in the config.

URL parameters are also supported but [not recommended by Google](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites):

```ruby
Arosa.config.hreflang_pattern = "https://example.com:path?loc=:locale"
```

When `hreflang_opt_in` is enabled in the config, pages must opt in:

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

Generate [schema.org](https://schema.org) structured data as JSON-LD. Pass a schema hash through `set_arosa` and it renders alongside your meta tags.

```ruby
set_arosa(
  title: "Acme Corp",
  description: "We make everything.",
  schema: {
    type: :organization,
    name: "Acme Corp",
    url: "https://acme.com",
    logo: "https://acme.com/logo.png",
    email: "hello@acme.com",
    founding_date: Date.new(2020, 1, 1),
    same_as: [
      "https://linkedin.com/company/acme",
      "https://en.wikipedia.org/wiki/Acme"
    ],
    address: { type: :postal_address, street_address: "123 Main St", address_locality: "Zug", address_country: "CH", postal_code: "6300" },
    contact_point: { type: :contact_point, contact_type: "customer service", telephone: "+1-800-555-1234", email: "support@acme.com" }
  }
)
```

Nested hashes with a `type:` key are automatically built into schema objects. The JSON-LD `<script>` tag is rendered by `arosa_tags` in the layout alongside everything else.

### Supported Types

| Type | Key | Schema.org |
|------|-----|------------|
| [Organization](#organization) | `:organization` | [schema.org/Organization](https://schema.org/Organization) |
| [PostalAddress](#postaladdress) | `:postal_address` | [schema.org/PostalAddress](https://schema.org/PostalAddress) |
| [ContactPoint](#contactpoint) | `:contact_point` | [schema.org/ContactPoint](https://schema.org/ContactPoint) |
| [BreadcrumbList](#breadcrumblist) | `:breadcrumb_list` | [schema.org/BreadcrumbList](https://schema.org/BreadcrumbList) |
| [ListItem](#listitem) | `:list_item` | [schema.org/ListItem](https://schema.org/ListItem) |
| [Language](#language) | `:language` | [schema.org/Language](https://schema.org/Language) |
| [WebApplication](#webapplication) | `:web_application` | [schema.org/WebApplication](https://schema.org/WebApplication) |
| [Article](#article) | `:article` | [schema.org/Article](https://schema.org/Article) |

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

### PostalAddress

| Property | Type |
|----------|------|
| street_address | String |
| address_locality | String |
| address_region | String |
| postal_code | String |
| address_country | String |

### ContactPoint

| Property | Type |
|----------|------|
| contact_type | String |
| telephone | String |
| email | String |
| available_language | Array of String or [Language](#language) |

### BreadcrumbList

| Property | Type |
|----------|------|
| item_list_element | Array of [ListItem](#listitem) |

```ruby
set_arosa schema: {
  type: :breadcrumb_list,
  item_list_element: [
    { type: :list_item, position: 1, name: "Home", item: "https://example.com" },
    { type: :list_item, position: 2, name: "Trails", item: "https://example.com/trails" },
    { type: :list_item, position: 3, name: "Arosa to Lenzerheide" }
  ]
}
```

### ListItem

| Property | Type |
|----------|------|
| position | Integer |
| name | String |
| item | String |

Note: `item` is optional on the last breadcrumb (the current page).

### Language

| Property | Type |
|----------|------|
| name | String |
| alternate_name | String |

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
set_arosa(
  title: "Arosa to Lenzerheide: The Complete Trail Guide",
  description: "Everything you need to know about the trail from Arosa to Lenzerheide.",
  schema: {
    type: :article,
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
  }
)
```

### Direct usage

Schemas can also be built and rendered directly without `set_arosa`:

```ruby
@schema = Arosa::Schemas::Organization.new(name: "Acme Corp", url: "https://acme.com")
```

```erb
<%= @schema %>
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
