# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "POST /api/games" do
  it 'creates a game' do
    expect { post '/api/games' }.to change(Game, :count).by(1)

    game = Game.last

    expect(game.frames.count).to eq(10)
    expect(response).to be_successful
    expect(JSON.parse(response.body).keys).to include('id')
  end
end
