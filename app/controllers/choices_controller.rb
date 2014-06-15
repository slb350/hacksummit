class ChoicesController < ApplicationController
  def new
    @player = player
    @choice = @player[:pending_choices].first

    @environment = OpenStruct.new sea_level: 2,
      temp: 80,
      precip: 5

    @resources = OpenStruct.new money: 200,
      food: 3,
      gas: 8
  end

  def create
    @player = player
    choice = @player[:pending_choices].unshift
    selected_option =
      choice[:options].select{|o| o[:id] == params[:choice_option]}.first
    raise ArgumentError.new("Invalid option specified") unless selected_option

    @player[:money] += selected_option[:impact][:resource]
    choice[:selected_option] = selected_option
    @player[:completed_choices].push choice

    if @player[:money] <= 0
      # Lose game if player money is less than 0?
      puts "game over dude"
    else
      redirect_to(map_show_path(:@player[:id]))
    end
  end
end
