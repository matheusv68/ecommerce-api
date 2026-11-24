class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name,
            presence: true,
            length: { maximum: 80 },
            uniqueness: { case_sensitive: false }
end
