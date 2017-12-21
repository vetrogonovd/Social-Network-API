class CreateMetaTags < ActiveRecord::Migration[5.1]
  create_table :meta_tags, id: :uuid do |t|
    t.references :object, type: :uuid, polymorphic: true, index: true
    t.string :meta_title
    t.string :meta_description
    t.string :meta_image
  end
end