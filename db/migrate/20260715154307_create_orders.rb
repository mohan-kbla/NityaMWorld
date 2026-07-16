class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null: true # null for guests
      t.string :status, default: "pending", null: false
      t.decimal :subtotal_amount, precision: 10, scale: 2, null: false
      t.decimal :shipping_amount, precision: 10, scale: 2, null: false
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.string :coupon_code
      t.string :payment_method, null: false
      t.string :payment_status, default: "pending", null: false
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.bigint :shipping_address_id, null: false
      t.bigint :billing_address_id, null: false
      t.string :tracking_number
      t.string :carrier
      t.text :notes

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :razorpay_order_id
    add_foreign_key :orders, :addresses, column: :shipping_address_id
    add_foreign_key :orders, :addresses, column: :billing_address_id
  end
end
