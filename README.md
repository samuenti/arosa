# Arosa

Generate [schema.org](https://schema.org) structured data as JSON-LD. Drop it into your pages and let search engines understand your content.

## Installation

```ruby
gem 'arosa'
```

Then `bundle install`.

## Usage

Arosa works anywhere in your Ruby code. Build the schema, then output it in your view.

Here's an example of an Organization schema:

```ruby
@org = Arosa::Schemas::Organization.new(
  name: "Acme Corp",
  url: "https://acme.com",
  logo: "https://acme.com/logo.png",
  email: "hello@acme.com",
  founding_date: Date.new(2020, 1, 1),
  address: Arosa::Schemas::PostalAddress.new(
    street_address: "123 Main St",
    address_locality: "Zug",
    address_country: "CH",
    postal_code: "6300"
  )
)
```

In your view:

```erb
<%= @org %>
```

Which will output:

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
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main St",
    "addressLocality": "Zug",
    "addressCountry": "CH",
    "postalCode": "6300"
  }
}
</script>
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

## Supported Types

| Type | Schema.org |
|------|------------|
| [Organization](#organization) | [schema.org/Organization](https://schema.org/Organization) |
| [PostalAddress](#postaladdress) | [schema.org/PostalAddress](https://schema.org/PostalAddress) |
| [ContactPoint](#contactpoint) | [schema.org/ContactPoint](https://schema.org/ContactPoint) |
| [BreadcrumbList](#breadcrumblist) | [schema.org/BreadcrumbList](https://schema.org/BreadcrumbList) |
| [ListItem](#listitem) | [schema.org/ListItem](https://schema.org/ListItem) |

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
Arosa::Schemas::Organization.new(
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

```ruby
Arosa::Schemas::ContactPoint.new(
  contact_type: "customer service",
  telephone: "+1-800-555-1234",
  email: "support@example.com"
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

## License

MIT
