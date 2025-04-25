class ApplicationController < ActionController::API
  before_action :set_cors_headers

  def options
    head :ok
  end

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '3600'
  end
end
