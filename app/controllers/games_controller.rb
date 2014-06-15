class GamesController < ApplicationController
  def splash
    #all the other apps we would build.
  end

  def welcome
    @parent_session_id = params[:parent_session_id]
    if @parent_session_id
      redirect_to new_game_path, parent_session_id: @parent_session_id and return
    end
  end

  def finished
    @session = current_session
  end

  def new
    @cars = [
      OpenStruct.new(name: "Prius"),
      OpenStruct.new(name: "Camry"),
      OpenStruct.new(name: "Volt")
    ]

    @parent_session_id = params[:parent_session_id]
    @parent_session = get_session(params[:parent_session_id]) unless params[:parent_session_id].to_s == ""
  end

  def create
    choices = choice_template

    @parent_session = get_session(params[:parent_session_id]) unless params[:parent_session_id].to_s == ""

    session = {}
    session[:id] = SecureRandom.uuid
    if @parent_session
      session[:name] = @parent_session[:name]
      session[:color] = @parent_session[:color]
      session[:parent_session_id] = @parent_session[:id]
      session[:iteration] = @parent_session[:iteration] + 1
      session[:initial_environment] = @parent_session[:environment]
    else
      session[:name] = params[:session_name]
      session[:color] = params[:session_color]
      session[:iteration] = 1
      session[:initial_environment] = 1
    end
    session[:starting_money] = 1000
    session[:money] = session[:starting_money]
    session[:environment] = session[:initial_environment]
    session[:total_miles] = choices.sum{|c| c[:location][:mileage] }
    session[:miles_remaining] = session[:total_miles]
    session[:pending_choices] = choices
    session[:completed_choices] = []

    # now persist session
    store_session(session)
    redirect_to new_choice_path(session_id: session[:id])
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
              cost: 125,
              cost_impact: 2,
              environment: 4
            }
          },
          {
            id: 2,
            description: "Air B'n'B has yet to let me down!",
            outcome: {
              cost: 75,
              cost_impact: 1.5,
              environment: 1
            }
          },
          {
            id: 3,
            description: "I'll see if there's a local hostel at the next city.",
            outcome: {
              cost: 100,
              cost_impact: 1.5,
              environment: 2
            }
          },
          {
            id: 4,
            description: "Let's buy gear go camping!",
            outcome: {
              cost: 500,
              cost_impact: 0,
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
              cost: 50,
              cost_impact: 3,
              environment: 3
            }
          },
          {
            id: 2,
            description: "I'll find a co-op and get some fresh groceries.",
            outcome: {
              cost: 75,
              cost_impact: 2,
              environment: 1
            }
          },
          {
            id: 3,
            description: "There's a great farm-to-table restaurant at the next exit!",
            resource_impact_description: <<-DESC ,
            DESC
            environmental_impact_description: <<-DESC ,
              Local food is not only healthier and tastier, it is also better for the
              environment because fewer transport miles equal fewer transmissions. According
              to a study conducted by the Leopold Center for Sustainable Agriculture at Iowa State University,
              food travels 1,500 miles on average from farm to customer while locally sourced food travels an average
              of 44.6 miles. The same study found that the conventional food distribution system uses 4 to 17 times more
              fuel and emits 5 to 17 times more CO2 than local and regional systems.
              However, the environmental impact of food depends not only on how long it travels, but also on how it is
              transported. Ton for ton, trains are far more efficient at moving freight than trucks are. This means that
              the greenhouse gases associated with transporting potatoes trucked in from 100 miles away is the same as those
              associated with potatoes shipped in by rail from 1,000 miles away.
            DESC
            outcome: {
              cost: 125,
              cost_impact: 2,
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
            resource_impact_description: <<-DESC ,
              2- 24 packs of bottled water cost $12. It will last you 8 days,
              but the weight that the cases of water adds to your car will affect your fuel economy.
            DESC
            environmental_impact_description: <<-DESC ,
              The weight that the case of water adds to your car will affect your fuel economy which
              affects the amount of gas you are using. Every time you buy a plastic drinking bottle,
              you are also using some of the world's limited supply of oil--manufacturers use petroleum
              to make and transport plastic products. Plastic bottle production in the U.S. requires millions
              of barrels of crude oil annually. Beverage companies then use fuel to transport the bottles all
              over the world, polluting the atmosphere in the process.
            DESC
            outcome: {
              cost: 40,
              cost_impact: 4,
              environment: 3
            }
          },
          {
            id: 2,
            description: "Buy a stainless steel water bottle and fill it at the tap",
            resource_impact_description: <<-DESC ,
              The stainless steel bottle costs $12.99. Can refill water for free.
            DESC
            environmental_impact_description: <<-DESC ,
              You save the fuel it costs to create water bottles and recycle them and
              the extra gas it takes to carry cases of water in your car.
            DESC
            outcome: {
              cost: 80,
              cost_impact: 2,
              environment: 1
            }
          },
          {
            id: 3,
            description: "Buy some 2 liters of soda instead",
            resource_impact_description: <<-DESC ,
              A 24 pack of bottled water costs $5.99. It will last you 4 days,
              but the weight that the cases of water adds to your car will affect your fuel economy
            DESC
            environmental_impact_description: <<-DESC ,
              Although you are using less water bottles than if you had bought 2 cases, the amount
              of fuel that it takes the companies that produce them to transport the products still
              takes the same amount of gas. The weight that the case of water adds to your car will
              affect your fuel economy which affects the amount of gas you are using. Every time you
              buy a plastic drinking bottle, you are also using some of the world's limited supply of
              oil manufacturers use petroleum to make and transport plastic products. Plastic bottle
              production in the U.S. requires millions of barrels of crude oil annually. Beverage
              companies then use fuel to transport the bottles all over the world, polluting the atmosphere in the process.
            DESC
            outcome: {
              cost: 60,
              cost_impact: 2.5,
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
