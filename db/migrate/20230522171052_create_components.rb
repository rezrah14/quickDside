class CreateComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :components do |t|
      t.string :name, null: false
      t.boolean :dependent_price_model, default: false
      t.timestamps
    end

    add_index :components, :name, unique: true
  end
end
