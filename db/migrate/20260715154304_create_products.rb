class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sku, null: false
      t.text :description
      t.text :short_description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :discount_price, precision: 10, scale: 2
      t.integer :stock, default: 0, null: false
      t.decimal :weight, precision: 8, scale: 2
      t.boolean :featured, default: false, null: false
      t.boolean :best_seller, default: false, null: false
      t.boolean :new_arrival, default: false, null: false
      t.decimal :rating, precision: 3, scale: 2, default: 0.0, null: false
      t.integer :reviews_count, default: 0, null: false
      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
    add_index :products, :price
    add_index :products, :featured
    add_index :products, :best_seller
    add_index :products, :new_arrival
  end
end
