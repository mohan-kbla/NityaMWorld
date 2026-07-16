class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.bigint :parent_id
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :categories, :name
    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
