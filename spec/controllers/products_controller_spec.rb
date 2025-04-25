# This tells RSpec we're testing the ProductsController
require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  # Helper method to create a valid product data hash
  def valid_product_data
    {
      name: "Test Product",
      description: "A test product",
      price: 10.99,
      available: true
    }
  end

  # Helper method to create an invalid product data hash
  def invalid_product_data
    {
      name: "",  # Invalid because name is required
      description: "",  # Invalid because description is required
      price: -1,  # Invalid because price can't be negative
      available: nil  # Invalid because available must be true or false
    }
  end

  # Test 1: GET /products (index action)
  describe "GET /products" do
    it "returns a list of all products" do
      # Create a test product in the database
      Product.create!(valid_product_data)
      
      # Make a GET request to /products
      get :index
      
      # Check if the response was successful (200 OK)
      expect(response).to be_successful
    end
  end

  # Test 2: GET /products/:id (show action)
  describe "GET /products/:id" do
    it "returns a specific product" do
      # Create a test product in the database
      product = Product.create!(valid_product_data)
      
      # Make a GET request to /products/:id
      get :show, params: { id: product.id }
      
      # Check if the response was successful (200 OK)
      expect(response).to be_successful
    end
  end

  # Test 3: POST /products (create action)
  describe "POST /products" do
    it "creates a new product with valid data" do
      # Make a POST request to /products with valid data
      post :create, params: { product: valid_product_data }
      
      # Check if the response indicates creation (201 Created)
      expect(response).to have_http_status(:created)
    end

    it "fails to create a product with invalid data" do
      # Make a POST request to /products with invalid data
      post :create, params: { product: invalid_product_data }
      
      # Check if the response indicates validation error (422 Unprocessable Entity)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # Test 4: PUT /products/:id (update action)
  describe "PUT /products/:id" do
    it "updates a product with valid data" do
      # Create a test product in the database
      product = Product.create!(valid_product_data)
      
      # Make a PUT request to /products/:id with new data
      put :update, params: { 
        id: product.id, 
        product: { name: "Updated Product" } 
      }
      
      # Check if the response was successful (200 OK)
      expect(response).to be_successful
    end
  end

  # Test 5: DELETE /products/:id (destroy action)
  describe "DELETE /products/:id" do
    it "deletes a product" do
      # Create a test product in the database
      product = Product.create!(valid_product_data)
      
      # Make a DELETE request to /products/:id
      delete :destroy, params: { id: product.id }
      
      # Check if the response indicates successful deletion (204 No Content)
      expect(response).to have_http_status(:no_content)
      
      # Try to find the deleted product (should raise error)
      expect { Product.find(product.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
