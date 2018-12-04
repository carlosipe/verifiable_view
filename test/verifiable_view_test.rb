$:.unshift File.expand_path("../../lib", __FILE__)
require_relative "support/setup_database_helper"
require 'verifiable_view'

class Product < ActiveRecord::Base
  scope :regular, -> { where(product_category: :regular) }
  scope :active, -> { where(deprecated: false) }
end

class RegularProduct < ActiveRecord::Base
  extend VerifiableView

  definition do
    Product.regular.active
  end
end

test ".verify" do
  VerifiableView.verification_method = (lambda do |expected, actual|
    assert_equal(expected, actual)
  end)

  RegularProduct.verify
end

test ".verify raises exception when missing code definition" do
  class NoDefinitionView < ActiveRecord::Base
    extend VerifiableView

    self.table_name = :regular_products
  end

  error = assert_raise do
    NoDefinitionView.verify
  end
  assert_equal("Missing view definition", error.message)
end

test ".verify with unmatched db definition" do
  class DeprecatedRegularProduct < ActiveRecord::Base
    extend VerifiableView
    self.table_name = :regular_products

    definition do
      Product.regular.where(deprecated: true)
    end
  end

  assert_raise do
    DeprecatedRegularProduct.verify
  end
end

test ".verify compares with nil when missing db view" do
  class NoView < ActiveRecord::Base
    extend VerifiableView

    definition do
      Product.regular
    end
  end

  values = {}
  VerifiableView.verification_method = (lambda do |expected, actual|
    values[:actual] = actual
    values[:expected] = expected
  end)

  NoView.verify
  assert values[:expected].downcase.include?("select")
  assert_equal(nil, values[:actual])
end
