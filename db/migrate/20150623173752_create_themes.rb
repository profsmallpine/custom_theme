class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.references :tenant, index: true, foreign_key: true
      t.string :font_color, limit: 7

      t.timestamps null: false
    end
  end
end
