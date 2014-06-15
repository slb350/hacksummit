class ChoicesController < ApplicationController
  def new
    @session = current_session
    @choice = @session[:pending_choices].first
    @progress_percent =
      (1 - (@session[:miles_remaining].to_f / @session[:total_miles])).round(2)*100
    @money_percent =
      (@session[:money].to_f / @session[:starting_money]).round(2)*100

    @choice[:options].each do |o|
      cost_multi = 1 + (@session[:initial_environment].to_f / 100)
      cost_multi *= 1 + (o[:outcome][:cost_impact].to_f / 10) if o[:outcome][:cost_impact]
      o[:outcome][:cost] = (o[:outcome][:cost] * cost_multi.to_f).to_i if cost_multi > 0
    end

    if @session[:parent_session_id]
      parent_session = get_session(@session[:parent_session_id])
      previous_choice = parent_session[:completed_choices]
        .select{|c| c[:id] == @choice[:id]}.first
      @previous_option_id = previous_choice[:selected_option][:id]
    end

    costs = @choice[:options].map{|o| o[:outcome][:cost]}.reject{|c| !c}
    event_prob = 0.1
    event_prob = (@session[:initial_environment].to_f / 100) * 2

    if rand < event_prob and @choice[:location][:type] != "start"
      @event = random_event
      @event[:cost] = (@event[:cost] * (1 + (@session[:initial_environment].to_f / 100))).to_i
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
    @session[:money] -= @session[:car][:gas_cost] * @session[:initial_environment].to_f / 100 * 2 if @session[:car]
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
