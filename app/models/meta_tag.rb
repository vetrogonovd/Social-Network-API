class MetaTag < ActiveRecord::Base

  validates_uniqueness_of :object_id, scope: [:meta_title, :meta_description, :meta_image, :meta_link]
  validates :meta_title, :meta_description,
            :meta_image, :meta_link, length: { maximum: 1000 }

  belongs_to :object, polymorphic: true
end