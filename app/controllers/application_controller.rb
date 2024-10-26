class ApplicationController < ActionController::API
  def disable_sessions
    request.session_options[:skip] = true
  end
end
