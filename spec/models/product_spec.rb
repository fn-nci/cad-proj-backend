# This tells RSpec we're testing the Product model
require 'rails_helper'

RSpec.describe Product, type: :model do
  # This is a helper method that creates a valid product for our tests
  # We can reuse this instead of writing the same product data many times
  def create_valid_product
    Product.new(
      name: "Test Product",
      description: "A test product",
      price: 10.99,
      available: true
    )
  end

  # Test 1: Check if we can create a valid product
  it "can be created with valid data" do
    product = create_valid_product
    # This checks if the product is valid (passes all validations)
    expect(product).to be_valid
  end

  # Test 2: Check if name is required
  it "requires a name" do
    product = create_valid_product
    product.name = nil  # Set name to nil to test validation
    # This checks if the product is invalid without a name
    expect(product).not_to be_valid
  end

  # Test 3: Check if description is required
  it "requires a description" do
    product = create_valid_product
    product.description = nil
    expect(product).not_to be_valid
  end

  # Test 4: Check if price must be positive
  it "requires a positive price" do
    product = create_valid_product
    product.price = -10  # Try to set a negative price
    expect(product).not_to be_valid
  end

  # Test 5: Check if available can be true or false
  it "can be available or unavailable" do
    product = create_valid_product
    
    # Test with available = true
    product.available = true
    expect(product).to be_valid
    
    # Test with available = false
    product.available = false
    expect(product).to be_valid
  end
end
