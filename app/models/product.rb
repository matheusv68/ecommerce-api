class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  validates :name, :description, :sku, presence: true
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: true

  validate :image_is_valid

  # no controller/serializer, usar image_url: product.image.attached? ? url_for(product.image) : nil

  private

  def image_is_valid
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:image, "must be JPEG, PNG or WebP")
    end

    if image.byte_size > 5.megabytes
      errors.add(:image, "must be 5 MB max")
    end
  end
end
