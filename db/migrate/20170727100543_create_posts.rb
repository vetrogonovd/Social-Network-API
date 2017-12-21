class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: { on_delete: :cascade }
      t.string :quote
      t.string :market
      t.string :recommend
      t.decimal :price
      t.string :access
      t.string :file
      t.text   :content

      t.datetime :forecast
      t.timestamps
    end
  end
end
