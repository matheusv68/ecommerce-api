class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :price_cents, null: false
      t.integer :stock_quantity, null: false, default: 0
      t.string :sku, null: false
      t.string :image_url
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :products, :sku, unique: true
    add_check_constraint :products, "price_cents >= 0", name: "products_price_cents_non_negative"
    add_check_constraint :products, "stock_quantity >= 0", name: "products_stock_quantity_non_negative"
  end
end
