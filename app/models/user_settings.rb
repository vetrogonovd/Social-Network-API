class UserSettings < ActiveRecord::Base

  validates :phone, :phone_2, length: { maximum: 20 }
  validates :skype, :status, length: { maximum: 50 }
  validates :country, :city, format: { with: /\D*/ }, length: { maximum: 50 }
  validates :language, inclusion: { in: proc { I18n.available_locales.map(&:to_s) } }

  belongs_to :user

  privacy = [:all, :followers, :hidden]

  enum show_phones:  privacy, _prefix: :phones
  enum show_skype:   privacy, _prefix: :skype
  enum show_country: privacy, _prefix: :country
  enum show_city:    privacy, _prefix: :city
  enum show_status:  privacy, _prefix: :status
end