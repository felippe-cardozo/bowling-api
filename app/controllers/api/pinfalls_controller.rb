# frozen_string_literal: true

module Api
  class PinfallsController < ApplicationController
    def create
      game_service = GameService.new(params[:game_id])

      game_service.add_pinfalls!(frame_number: params[:number].to_i,
                                 ball_number: ball_number,
                                 pinfalls: pinfalls)

      head :created
    end

    private

    def pinfalls
      params.require(:pinfalls).to_i
    end

    def ball_number
      params.require(:ball_number).to_i
    end
  end
end
