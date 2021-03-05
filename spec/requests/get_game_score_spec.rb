# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "GET /api/games/:id/score" do
  let(:game) { GameService.create_with_initial_state! }

  context 'when game is perfect' do
    it 'returns score 300 and detailed score by frames' do
      game.frames.each do |frame|
        frame.balls << Ball.new(number: 1, pinfalls: 10)
      end

      last_frame = game.frames.find_by(number: 10)
      last_frame.balls << Ball.new(number: 2, pinfalls: 10)
      last_frame.balls << Ball.new(number: 3, pinfalls: 10)


      get "/api/games/#{game.id}/score"

      expect(response.status).to eq(200)

      expect(JSON.parse(response.body).deep_symbolize_keys).to eq(
        { total_score: 300,
          frames_score: [{ number: 1, score: 30 },
                         { number: 2, score: 30 },
                         { number: 3, score: 30 },
                         { number: 4, score: 30 },
                         { number: 5, score: 30 },
                         { number: 6, score: 30 },
                         { number: 7, score: 30 },
                         { number: 8, score: 30 },
                         { number: 9, score: 30 },
                         { number: 10, score: 30 }] }
      )
    end

    it 'matches the schema' do
      post '/api/games'
      game.frames.each do |frame|
        frame.balls << Ball.new(number: 1, pinfalls: 10)
      end

      get "/api/games/#{game.id}/score"

      expect(response).to match_response_schema('score')
    end
  end

  context 'when game is not found' do
    it 'returns 404' do
      get "/api/games/3f4bd7e6-80f0-495d-97ed-11ab4f558c6d/score"

      expect(response.status).to eq(404)
    end
  end
end
