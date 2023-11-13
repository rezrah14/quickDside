class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.string :region
      t.string :company_name
      t.integer :asset_type
      t.date :start_date
      t.date :end_date
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
