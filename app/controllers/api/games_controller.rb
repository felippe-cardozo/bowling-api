# frozen_string_literal: true

module Api
  class GamesController < ApplicationController
    def create
      game = Game.create!

      render json: game
    end
  end
end
