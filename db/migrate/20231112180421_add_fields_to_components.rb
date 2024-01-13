class AddFieldsToComponents < ActiveRecord::Migration[7.0]
  def change
    # Remove columns
    remove_column :components, :dependent_price_model, :boolean

    # Remove indexes
    remove_index :components, name: "index_components_on_name"
    remove_index :components, name: "index_components_on_project_id"

    # Add new columns
    add_column :components, :quantity_type, :integer, default: 0
    add_column :components, :unit_multiplier, :integer, default: 2
    add_column :components, :unit, :integer, default: 0
    add_column :components, :price_interpolation_model, :integer, default: 0
    add_column :components, :currency, :integer, default: 0
  end
end
