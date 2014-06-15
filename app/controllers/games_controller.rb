class GamesController < ApplicationController
  def welcome
  end

  def finished
    @player = current_player
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
    player[:starting_money] = 600
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
          mileage: 575
        },
        description: "Choose your car",
        options: [
          {
            id: 1,
            description: "Prius",
            outcome: {
              car: {
                name: "prius",
                gas_cost: 20
              },
              cost: 200
            }
          },
          {
            id: 2,
            description: "Camry",
            outcome: {
              car: {
                name: "camry",
                gas_cost: 75
              },
              cost: 150
            }
          },
          {
            id: 3,
            description: "Volt",
            outcome: {
              car: {
                name: "volt",
                gas_cost: 0
              },
              cost: 400
            }
          }
        ]
      },
      {
        location: {
          name: "Las Vegas, NV",
          lat: "36.1",
          long: "-115.2",
          mileage: 750
        },
        description: "You only brought enough water for one day",
        options: [
          {
            id: 1,
            description: "You can buy 2 whole cases of bottled water at Costco",
            outcome: {
              cost: 25,
              environment: 3
            }
          },
          {
            id: 2,
            description: "You can buy a stainless steel water bottle",
            outcome: {
              cost: 75,
              environment: 1
            }
          },
          {
            id: 3,
            description: "You can buy one whole case of bottled water and use a stainless steel bottle when you can",
            outcome: {
              cost: 100,
              environment: 2.5
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
        description: "It's dinner time, and you've been driving for six hours straight",
        options: [
          {
            id: 1,
            description: "Do you pull over at one of the fast food joints?",
            outcome: {
              cost: 45,
              environment: 3
            }
          },
          {
            id: 2,
            description: "Do you eat the food you packed earlier for your trip?",
            outcome: {
              cost: 24,
              environment: 1
            }
          },
          {
            id: 3,
            description: "Do you eat at a restaurant that is farm-to-table?",
            outcome: {
              cost: 150,
              environment: 2
            }
          }
        ]
      },
      {
        location: {
          name: "Chicago, IL",
          lat: "41.2",
          long: "-87.6",
          mileage: 1450
        },
        description: "Where do you stay tonight?",
        options: [
          {
            id: 1,
            description: "Stay at a hotel/motel",
            outcome: {
              cost: 200,
              environment: 3
            }
          },
          {
            id: 2,
            description: "Start at a friend's home",
            outcome: {
              cost: 0,
              environment: 1
            }
          },
          {
            id: 3,
            description: "Stay at a local hostel",
            outcome: {
              cost: 60,
              environment: 2
            }
          },
          {
            id: 4,
            description: "Go camping",
            outcome: {
              cost: 35,
              environment: 1
            }
          }
        ]
      },
      {
        location: {
          name: "Pittsburg, PA",
          lat: "40.3",
          long: "-76.9",
          mileage: 700
        },
        description: "Your car is broken down WHAT DO YOU DO",
        options: [
          {
            id: 1,
            description: "Wait for help",
            outcome: {
              cost: 100,
              environment: 3
            }
          }
        ]
      }
    ]
  end
end
