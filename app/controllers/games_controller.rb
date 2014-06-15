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
    player = {}.tap do |p|
      p[:id] = SecureRandom.uuid
      p[:name] = params[:player_name] || "Player 1"
      p[:color] = params[:player_color] || "#6E913F"
      p[:pending_choices] = standard_choices
      p[:completed_choices] = []
    end

    # now persist player
  end

  protected

  def standard_choices
    [
      {
        location: {
          name: "San Francisco",
          lat: "37.8",
          long: "122.4"
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            description: "Wait for help",
            impact: {
              resources: {
                food: -5,
                gas: 10
              },
              environment: {
                sea_level: 0.1
              }
            }
          }
        ]
      }
    ]
  end
end
