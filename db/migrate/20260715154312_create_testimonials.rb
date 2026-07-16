class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    create_table :testimonials do |t|
      t.string :author_name, null: false
      t.string :author_designation
      t.text :content, null: false
      t.integer :rating, default: 5, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :testimonials, :active
  end
end
