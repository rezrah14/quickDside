class AddFieldsToComponents < ActiveRecord::Migration[7.0]
  def change
    # Remove columns
    remove_column :components, :dependent_price_model, :boolean

    # Remove indexes
    remove_index :components, name: "index_components_on_name"
    remove_index :components, name: "index_components_on_project_id"

    # Add new columns
    add_column :components, :quantity_type, :string
    add_column :components, :unit_multiplier, :decimal
    add_column :components, :unit, :string
    add_column :components, :price_interpolation_model, :string
    add_column :components, :currency, :string
  end
end
