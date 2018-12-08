# Verifiable View

Keep your database view definitions in sync with your named scopes and
associations' definitions.

## Installation

`gem install verifiable_view`

## Usage

```rb
class RegularProduct
  extend VerifiableView

  definition do
    Product.not_deprecated.where(..)
  end
end
```

Then in your tests you'll have a
```rb
RegularProduct.verify
```

That will check that you have a `regular_products` view defined in your database
and that the query matches with your definition (Products that are not
deprecated, etc)

## Why

Named scopes and named associations are easy to write with Arel and easy to
maintain. Every time you write a view by crafting your SQL by hand you risk
forgetting a condition. If you already have a definition of your associations,
why to violate DRYness and duplicate them?

Also when updating the definition of a named scope, you will notice immediately
that your view got out of your sync.

## Testing

`gem install dep`
`dep install`
`cutest test/*.rb`
