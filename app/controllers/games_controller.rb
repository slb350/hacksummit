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
    player[:starting_money] = 5000
    player[:money] = player[:starting_money]
    player[:environment] = 0
    player[:total_miles] = choices.sum{|c| c[:location][:mileage] }
    player[:miles_remaining] = player[:total_miles]
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
          long: "-122.4",
          mileage: 0
        },
        description: "Choose your car",
        options: [
          {
            id: 1,
            description: "Prius",
            outcome: {
              car: "prius",
              cost: 500
            }
          },
          {
            id: 2,
            description: "Camry",
            outcome: {
              car: "camry",
              cost: 100
            }
          },
          {
            id: 3,
            description: "Volt",
            outcome: {
              car: "volt",
              cost: 700
            }
          }
        ]
      },
      {
        location: {
          name: "Las Vegas, NV",
          lat: "36.1",
          long: "-115.2",
          mileage: 100
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              cost: 20,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "Denver, CO",
          lat: "39.7",
          long: "-105",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              cost: 2,
              environment: 3
            }
          },
          {
            id: 2,
            description: "Wait for help",
            outcome: {
              cost: 200000,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "Chicago, IL",
          lat: "41.2",
          long: "-87.6",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              cost: 2,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "Pittsburg, PA",
          lat: "40.3",
          long: "-76.9",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              cost: 2,
              environment: 3
            }
          }
        ]
      },
      {
        location: {
          name: "New York, NY",
          lat: "40.7",
          long: "-74",
          mileage: 250
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              cost: 2,
              environment: 3
            }
          }
        ]
      }
    ]
  end
end
