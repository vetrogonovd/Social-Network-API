class CreateGroupsAndGroupsUsersRelation < ActiveRecord::Migration[5.1]
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.string :access, default: 'Public'
      t.string :image, default: ''

      t.timestamps
    end

    create_table :group_users do |t|
      t.references :group, type: :uuid, index: true, foreign_key: { on_delete: :cascade }
      t.references :user, type: :uuid, index: true, foreign_key: { on_delete: :cascade }
      t.integer :role, default: 2
    end

    add_index :group_users, [:group_id, :user_id], unique: true
  end
end