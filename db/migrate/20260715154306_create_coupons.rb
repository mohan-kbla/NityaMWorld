class CreateCoupons < ActiveRecord::Migration[8.1]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.string :discount_type, null: false # "percentage", "flat", "free_shipping"
      t.decimal :discount_value, precision: 10, scale: 2, null: false
      t.datetime :expiry_date
      t.integer :usage_limit
      t.integer :usage_count, default: 0, null: false
      t.decimal :min_order_amount, precision: 10, scale: 2, default: 0.0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :coupons, :code, unique: true
    add_index :coupons, :active
  end
end
