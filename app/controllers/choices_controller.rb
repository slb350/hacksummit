class ChoicesController < ApplicationController
  def new
    @session = current_session
    @choice = @session[:pending_choices].first
    @progress_percent =
      (1 - (@session[:miles_remaining].to_f / @session[:total_miles])).round(2)*100
    @money_percent =
      (@session[:money].to_f / @session[:starting_money]).round(2)*100

    costs = @choice[:options].map{|o| o[:outcome][:cost]}.reject{|c| !c}
    if rand < 0.25 and @choice[:location][:type] != "start"
      @event = random_event
      @session[:money] -= @event[:cost]
    end
    if costs.count > 0 and @session[:money] <= costs.min
      @out_of_money = true
    end
    store_session(@session)
  end

  def create
    @session = current_session
    choice = @session[:pending_choices].shift
    selected_option =
      choice[:options].select{|o| o[:id] == params[:option_id].to_i}.first
    raise ArgumentError.new("Invalid option specified") unless selected_option

    @session[:money] -= selected_option[:outcome][:cost] if selected_option[:outcome][:cost]
    @session[:money] -= @session[:car][:gas_cost] if @session[:car]
    @session[:miles_remaining] -= choice[:location][:mileage]
    @session[:environment] += selected_option[:outcome][:environment] if selected_option[:outcome][:environment]
    @session[:car] = selected_option[:outcome][:car] if selected_option[:outcome][:car]
    choice[:selected_option] = selected_option
    @session[:completed_choices].push choice

    store_session(@session)
    if @session[:pending_choices].count == 0
      redirect_to(finished_path session_id: @session[:id])
    else
      redirect_to(new_choice_path session_id: @session[:id])
    end
  end

  protected

  def random_event
    [
      {
        description: "You got a flat tire!",
        cost: 125
      },
      {
        description: "Storms slow you down!",
        cost: 125
      },
      {
        description: "Accident slows you down!",
        cost: 125
      },
      {
        description: "Gas prices spike!",
        cost: 125
      }
    ].sample
  end
end
