class GamesController < ApplicationController
  def welcome
  end

  def finished
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

    player = {}
    player[:id] = SecureRandom.uuid
    player[:name] = params[:player_name] || "Player 1"
    player[:color] = params[:player_color] || "#6E913F"
    player[:money] = 100
    player[:miles_remaining] = choices.sum{|c| c[:location][:mileage] }
    player[:pending_choices] = choices
    player[:completed_choices] = []

    # now persist player
    store_player(player)
    redirect_to new_choice_path(player_id: player[:id])
  end

  protected

  def choice_template
    [
      {
        location: {
          name: "San Francisco, CA",
          lat: "37.8",
          long: "122.4",
          mileage: 0
        },
        description: "Choose your car",
        options: [
          {
            id: 1,
            description: "Prius",
            outcome: {
              car: "prius"
            }
          },
          {
            id: 2,
            description: "Camry",
            outcome: {
              car: "camry"
            }
          },
          {
            id: 3,
            description: "Volt",
            outcome: {
              car: "volt"
            }
          }
        ]
      },
      {
        location: {
          name: "Las Vegas, NV",
          lat: "37.8",
          long: "122.4",
          mileage: 100
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              resource: -2,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "Denver, CO",
          lat: "37.8",
          long: "122.4",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              resource: -2,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "New York, NY",
          lat: "37.8",
          long: "122.4",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              resource: -2,
              environment: 3
            }
          }
        ]
      }
    ]
  end
end
