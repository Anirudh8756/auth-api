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
    begin
      token = request.headers['Authorization']&.split(' ')&.last
      if token.nil?
        return render json: { status: 401, message: "Authorization token missing" }, status: :unauthorized
      end

      # Decode the JWT token
      jwt_payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first
      current_user = User.find_by(id: jwt_payload['sub'])

      if current_user
        render json: {
          status: 200,
          message: "Signed out successfully"
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "User has no active session"
        }, status: :unauthorized
      end

    rescue JWT::DecodeError
      render json: { status: 401, message: "Invalid token" }, status: :unauthorized
    rescue => e
      Rails.logger.error("Unexpected error in SessionsController#respond_to_on_destroy: #{e.message}")
      render json: { status: 500, message: "Internal server error" }, status: :internal_server_error
    end
  end


end
