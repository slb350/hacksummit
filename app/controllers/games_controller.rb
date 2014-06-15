class GamesController < ApplicationController
  def welcome
  end

  def new
    @cars = [
      OpenStruct.new(name: "Prius"),
      OpenStruct.new(name: "Camry"),
      OpenStruct.new(name: "Volt")
    ]
  end

  def create
    choices = [

    ]

    player = {}.tap do |p|
      p[:name] = params[:player_name]
      p[:color] = params[:player_color]
      p[:pending_choices] = choices
      p[:completed_choices] = []
    end

    # now persist player
  end
end
