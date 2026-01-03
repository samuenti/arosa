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
| Organization | [schema.org/Organization](https://schema.org/Organization) |
| PostalAddress | [schema.org/PostalAddress](https://schema.org/PostalAddress) |
| ContactPoint | [schema.org/ContactPoint](https://schema.org/ContactPoint) |
| BreadcrumbList | [schema.org/BreadcrumbList](https://schema.org/BreadcrumbList) |
| ListItem | [schema.org/ListItem](https://schema.org/ListItem) |

More types coming.

## License

MIT
