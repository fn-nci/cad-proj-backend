require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Product.new(
      name: "Test Product",
      description: "A test product description",
      price: 9.99,
      available: true
    )
  end

  test "should be valid" do
    assert @product.valid?
  end

  test "name should be present" do
    @product.name = ""
    assert_not @product.valid?
  end

  test "description should be present" do
    @product.description = ""
    assert_not @product.valid?
  end

  test "price should be present" do
    @product.price = nil
    assert_not @product.valid?
  end

  test "price should be greater than or equal to 0" do
    @product.price = -1
    assert_not @product.valid?
  end

  test "available should be boolean" do
    @product.available = nil
    assert_not @product.valid?
  end
end
