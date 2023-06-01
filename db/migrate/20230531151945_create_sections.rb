class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.references :space, null: false, foreign_key: true
      t.string :name, null: false, limit: 255

      t.timestamps
    end
  end
end
