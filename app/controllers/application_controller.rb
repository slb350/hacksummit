class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_player
    player_id = params[:player_id]
    get_player(player_id)
  end

  def store_player(player)
    $redis.set player[:id], player.to_json
  end

  def get_player(player_id)
    JSON.parse $redis.get(player_id)
  end
end
