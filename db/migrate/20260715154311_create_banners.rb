class CreateBanners < ActiveRecord::Migration[8.1]
  def change
    create_table :banners do |t|
      t.string :title
      t.string :subtitle
      t.string :link_url
      t.boolean :active, default: true, null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :banners, :active
    add_index :banners, :position
  end
end
