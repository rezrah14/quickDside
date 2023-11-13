class CreateAssetTags < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_tags do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
