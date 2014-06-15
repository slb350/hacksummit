class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_session
    session_id = params[:session_id]
    get_session(session_id)
  end

  def store_session(session)
    $redis.set session[:id], session.to_json
  end

  def get_session(session_id)
    JSON.parse $redis.get(session_id), symbolize_names: true
  end
end
