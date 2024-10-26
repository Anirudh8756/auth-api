# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

private

  def respond_with(resource, options={})
      render json: {
        status: {
          code: 200 ,
          message: 'User Signed in Successfully',
          data: current_user
        }
      }, status: :ok
  end

  def respond_to_on_destroy
    # Ensure the Authorization header is correctly formatted
    auth_header = request.headers['Authorization']
    if auth_header.present? && auth_header.start_with?('Bearer ')
      # Extract the token
      token = auth_header.split(' ')[1]

      begin
        # Decode the JWT token
        jwt_payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find_by(id: jwt_payload['sub'])

        # Check if user exists
        if current_user
          render json: { status: 200, message: "Signed out successfully" }, status: :ok
        else
          render json: { status: 401, message: "User not found" }, status: :unauthorized
        end

      rescue JWT::DecodeError => e
        render json: { status: 401, message: "Invalid token: #{e.message}" }, status: :unauthorized
      end

    else
      render json: { status: 401, message: "Authorization header not provided or incorrect format" }, status: :unauthorized
    end
  end

end
