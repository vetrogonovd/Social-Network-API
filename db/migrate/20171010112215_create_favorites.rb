class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :user, type: :uuid, foreign_key: { on_delete: :cascade }
      t.string :quote
    end

    add_index :favorites, [:user_id, :quote], unique: true
  end
end