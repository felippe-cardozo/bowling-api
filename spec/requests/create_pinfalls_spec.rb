# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "POST /api/games/:id/frames/:number/pinfalls" do
  context 'when everything is valid' do
    it 'creates a ball with a number of pinfalls for the given frame' do
      game = GameService.create_with_initial_state!
      params = { ball_number: 1, pinfalls: 4 }

      expect { post "/api/games/#{game.id}/frames/1/pinfalls", params: params }.to change(Ball, :count).by(1)

      frame = game.frames.find_by(number: 1)
      ball = frame.balls.first

      expect(frame.balls.count).to eq(1)
      expect(ball.pinfalls).to eq(4)
    end
  end

  context 'when ball_number is duplicated for frame' do
    it 'returns 409, conflict' do
      game = GameService.create_with_initial_state!
      params = { ball_number: 1, pinfalls: 4 }

      post "/api/games/#{game.id}/frames/1/pinfalls", params: params
      expect(response.status).to eq(201)

      post "/api/games/#{game.id}/frames/1/pinfalls", params: params
      expect(response.status).to eq(409)

    end
  end

  context 'when game is not valid' do
    it 'returns 422' do
      game = GameService.create_with_initial_state!
      params = { ball_number: 1, pinfalls: 11 }

      post "/api/games/#{game.id}/frames/1/pinfalls", params: params

      expect(response.status).to eq(422)
    end
  end

  context 'when params are missing' do
    it 'returns 400' do
      game = GameService.create_with_initial_state!
      params = { ball_number: 1 }

      post "/api/games/#{game.id}/frames/1/pinfalls", params: params

      expect(response.status).to eq(400)
    end
  end
end
