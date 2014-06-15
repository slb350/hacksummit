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
    choices = choice_template

    player = {}.tap do |p|
      p[:id] = SecureRandom.uuid
      p[:name] = params[:player_name] || "Player 1"
      p[:color] = params[:player_color] || "#6E913F"
      p[:money] = 100
      p[:miles_remaining] = choices.sum{|c| c[:location][:mileage] }
      p[:pending_choices] = choices
      p[:completed_choices] = []
    end

    # now persist player
  end

  protected

  def choice_template
    [
      {
        location: {
          name: "San Francisco",
          lat: "37.8",
          long: "122.4",
          mileage: 0
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            description: "Wait for help",
            impact: {
              resource: -2,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "San Francisco",
          lat: "37.8",
          long: "122.4",
          mileage: 100
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            description: "Wait for help",
            impact: {
              resource: -2,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "San Francisco",
          lat: "37.8",
          long: "122.4",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            description: "Wait for help",
            impact: {
              resource: -2,
              environment: 3
            }
          }
        ]
      }
    ]
  end
end
