class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.references :space, null: false, foreign_key: true
      t.references :follower, null: false, foreign_key: { to_table: :vocabularies }
      t.references :followed, null: false, foreign_key: { to_table: :vocabularies }
      t.integer :language_type, default: 0
      t.integer :positions, array: true, default: []

      t.timestamps
    end
    add_index :relationships, [:follower_id, :followed_id, :language_type], unique: true, name: 'index_relationships_on_follower_id_followed_id_language_type'
  end
end
