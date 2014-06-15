class ChoicesController < ApplicationController
  def new
    @current_user = current_user

    @environment = OpenStruct.new sea_level: 2,
      temp: 80,
      precip: 5

    @resources = OpenStruct.new money: 200,
      food: 3,
      gas: 8
  end

  def create
  end
end
