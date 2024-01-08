class ChangeComponentFieldsToEnum < ActiveRecord::Migration[7.0]
  def change
    change_column :components, :quantity_type, :integer, default: 0
    change_column :components, :unit, :integer, default: 0
    change_column :components, :unit_multiplier, :integer, default: 2 # Modify the default as per your requirement
    change_column :components, :price_interpolation_model, :integer, default: 0
    change_column :components, :currency, :integer, default: 0
  end
end
