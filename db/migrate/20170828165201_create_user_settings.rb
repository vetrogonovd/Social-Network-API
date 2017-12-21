class CreateUserSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_settings do |t|
      t.references :user, type: :uuid, index: { unique: true }, foreign_key: { on_delete: :cascade }

      t.string :language, default: 'en'
      t.string :phone
      t.string :phone_2
      t.string :skype
      t.string :country
      t.string :city
      t.string :status

      t.integer :show_phones,  default: 0
      t.integer :show_skype,   default: 0
      t.integer :show_country, default: 0
      t.integer :show_city,    default: 0
      t.integer :show_status,  default: 0
    end
  end
end