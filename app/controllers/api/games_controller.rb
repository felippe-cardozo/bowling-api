# frozen_string_literal: true

module Api
  class GamesController < ApplicationController
    def create
      game = Game.create_with_initial_state!

      render json: game
    end
  end
end
