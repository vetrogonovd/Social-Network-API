class CreateLikes < ActiveRecord::Migration[5.1]
  create_table :likes, id: :uuid do |t|
    t.references :user, type: :uuid, index: true, foreign_key: { on_delete: :cascade }
    t.references :liked, type: :uuid, polymorphic: true, index: true
    t.timestamps
  end
end
