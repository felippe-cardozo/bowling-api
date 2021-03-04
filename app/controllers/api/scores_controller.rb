# frozen_string_literal: true

module Api
  class ScoresController < ApplicationController
    def show
      service = ScoreService.new(params[:game_id])
      service.calculate_score

      render status: 200, json: { total_score: service.total_score,
                                  frames_score: service.frames_score }
    end
  end
end
