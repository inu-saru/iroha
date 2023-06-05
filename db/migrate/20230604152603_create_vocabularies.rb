class CreateVocabularies < ActiveRecord::Migration[7.0]
  def change
    create_table :vocabularies do |t|
      t.integer :vocabulary_type, default: 0
      t.string :en
      t.string :ja
      t.references :space, null: false, foreign_key: true
      t.references :section, null: true, foreign_key: true

      t.timestamps
    end
  end
end
