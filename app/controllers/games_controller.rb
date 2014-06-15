class GamesController < ApplicationController
  def splash
    #all the other apps we would build.
  end

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
    player[:starting_money] = 1000
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
          mileage: 575,
          type: "start"

        },
        description: "First, you have to pick a rental car! Choose carefully, because you'll also be paying for gas each day depending on the fuel economy of your vehicle!",
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
        description: "No one can drive all day (what is this a hackathon?), so it's time to find a place to crash. Where will you stay tonight?",
                options: [
          {
            id: 1,
            description: "I'll just find a hotel.",
            outcome: {
              cost: 200,
              environment: 4
            }
          },
          {
            id: 2,
            description: "Air B'n'B has yet to let me down!",
            outcome: {
              cost: 50,
              environment: 1
            }
          },
          {
            id: 3,
            description: "I'll see if there's a local hostel at the next city.",
            outcome: {
              cost: 50,
              environment: 2
            }
          },
          {
            id: 4,
            description: "Let's go camping!",
            outcome: {
              cost: 75,
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
        description: "It's dinner time, and you've been driving for six hours straight. It's time to eat, but where will you go?",
        options: [
          {
            id: 1,
            description: "McDonald's is fine. No use in being picky.",
            outcome: {
              cost: 10,
              environment: 3
            }
          },
          {
            id: 2,
            description: "I'll find a co-op and get some fresh groceries.",
            outcome: {
              cost: 24,
              environment: 1
            }
          },
          {
            id: 3,
            description: "There's a great farm-to-table restaurant at the next exit!",
            outcome: {
              cost: 50,
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
        description: "You're getting thirsty and you're out of water, what will you buy to drink?",
        options: [
          {
            id: 1,
            description: "Buy 2 whole cases of bottled water at Costco",
            outcome: {
              cost: 10,
              environment: 3
            }
          },
          {
            id: 2,
            description: "Buy a stainless steel water bottle and fill it at the tap",
            outcome: {
              cost: 20,
              environment: 1
            }
          },
          {
            id: 3,
            description: "Buy a 2 liter of soda instead",
            outcome: {
              cost: 5,
              environment: 2.5
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
