class ApiController < ApplicationController
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
      render json: {
        "warning": exception ,
        "status": "Authorization Denied"
      }
  end
end
