require "active_record"

ActiveRecord::Base.establish_connection(
  adapter:  "postgresql",
  database: "verifiable_view",
  encoding: "utf8",
  host: "localhost",
  min_messages: "warning"
)

class CreateSchema < ActiveRecord::Migration[5.2]
  def self.up
    execute <<~SQL
      DROP VIEW IF EXISTS regular_products
    SQL

    create_table :products, force: true do |table|
      table.string :product_category, null: false
      table.boolean :deprecated, null: false
    end

    execute <<-SQL
      CREATE VIEW regular_products AS
      SELECT "products".* FROM "products" WHERE "products"."product_category" = 'regular' AND "products"."deprecated" = FALSE
    SQL
  end
end

CreateSchema.suppress_messages do
  CreateSchema.migrate(:up)
end
