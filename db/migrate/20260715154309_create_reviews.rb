class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating, null: false
      t.string :title
      t.text :body
      t.string :status, default: "pending", null: false # pending, approved, rejected

      t.timestamps
    end

    add_index :reviews, :rating
    add_index :reviews, :status
  end
end
