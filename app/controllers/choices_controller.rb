class ChoicesController < ApplicationController
  def new
    @player = current_player
    @choice = @player[:pending_choices].first
    @progress_percent =
      (1 - (@player[:miles_remaining].to_f / @player[:total_miles])).round(2)*100
    @money_percent =
      (@player[:money].to_f / @player[:starting_money]).round(2)*100

    costs = @choice[:options].map{|o| o[:outcome][:cost]}.reject{|c| !c}
    if rand < 0.25
      @event = random_event
      @player[:money] -= @event[:cost]
    end
    if costs.count > 0 and @player[:money] <= costs.min
      @out_of_money = true
    end
  end

  def create
    @player = current_player
    choice = @player[:pending_choices].shift
    selected_option =
      choice[:options].select{|o| o[:id] == params[:option_id].to_i}.first
    raise ArgumentError.new("Invalid option specified") unless selected_option

    @player[:money] -= selected_option[:outcome][:cost] if selected_option[:outcome][:cost]
    @player[:miles_remaining] -= choice[:location][:mileage]
    @player[:environment] += selected_option[:outcome][:environment] if selected_option[:outcome][:environment]
    @player[:car] = selected_option[:outcome][:car] if selected_option[:outcome][:car]
    choice[:selected_option] = selected_option
    @player[:completed_choices].push choice

    store_player(@player)
    if @player[:pending_choices].count == 0
      redirect_to("/finished", player_id: @player[:id])
    else
      redirect_to(new_choice_path(player_id: @player[:id]))
    end
  end

  protected

  def random_event
    [
      {
        description: "You got a flat tire!",
        cost: 100
      },
      {
        description: "Storms slow you down!",
        cost: 100
      },
      {
        description: "Accident slows you down!",
        cost: 100
      },
      {
        description: "Gas prices spike!",
        cost: 100
      }
    ]
  end
end
