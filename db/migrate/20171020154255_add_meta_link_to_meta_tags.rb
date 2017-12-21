class AddMetaLinkToMetaTags < ActiveRecord::Migration[5.1]
  def change
    add_column :meta_tags, :meta_link, :string
  end
end
