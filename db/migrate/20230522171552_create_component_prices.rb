# db/migrate/20230523120001_create_component_prices.rb
class CreateComponentPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :component_prices do |t|
      t.references :component, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :realistic_price, precision: 10, scale: 2, null: false
      t.decimal :optimistic_price, precision: 10, scale: 2
      t.decimal :pessimistic_price, precision: 10, scale: 2
      t.string :currency, null: false
      t.string :tag, null: false
      t.timestamps
    end

    add_index :component_prices, [:component_id, :date], unique: true
  end
end
