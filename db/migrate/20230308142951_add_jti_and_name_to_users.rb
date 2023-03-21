class AddJtiAndNameToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name, null: false, default: ""
      t.string :jti
    end
    add_index :users, :jti
  end
end
