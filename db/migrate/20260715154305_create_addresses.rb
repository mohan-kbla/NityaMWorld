class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :user, type: :bigint ,foreign_key: true, null: true
      t.string :address_type, null: false # "shipping" or "billing"
      t.string :full_name, null: false
      t.string :address_line1, null: false
      t.string :address_line2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :country, default: "India", null: false
      t.string :phone, null: false

      t.timestamps
    end

    add_index :addresses, :address_type
  end
end
