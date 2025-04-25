class Product < ApplicationRecord
  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :available, inclusion: { in: [true, false] }
end
