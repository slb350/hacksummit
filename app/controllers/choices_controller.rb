class ChoicesController < ApplicationController
  def new
    @player = current_player
    @choice = @player[:pending_choices].first
  end

  def create
    @player = current_player
    choice = @player[:pending_choices].shift
    selected_option =
      choice[:options].select{|o| o[:id] == params[:option_id].to_i}.first
    raise ArgumentError.new("Invalid option specified") unless selected_option

    @player[:money] += selected_option[:outcome][:resource] if selected_option[:outcome][:resource]
    @player[:car] = selected_option[:outcome][:car] if selected_option[:outcome][:car]
    choice[:selected_option] = selected_option
    @player[:completed_choices].push choice

    store_player(@player)
    if @player[:money] <= 0 || @player[:pending_choices].count == 0
      redirect_to("/finished", player_id: @player[:id])
    else
      redirect_to(new_choice_path(player_id: @player[:id]))
    end
  end
end
