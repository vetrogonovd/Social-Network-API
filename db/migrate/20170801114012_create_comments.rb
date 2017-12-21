class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: { on_delete: :cascade }
      t.references :commentable, type: :uuid, polymorphic: true, index: true
      t.text :content
      t.string :file

      t.timestamps
    end
  end
end