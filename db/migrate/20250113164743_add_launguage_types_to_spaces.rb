class AddLaunguageTypesToSpaces < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :language_types, :integer, array: true, null: false, default: []
  end
end
