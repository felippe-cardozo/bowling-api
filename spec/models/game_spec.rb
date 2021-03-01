# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  describe '.create_with_intial_state!' do
    it 'creates the game with all 10 frames' do
      game = described_class.create_with_initial_state!

      expect(game).to be_persisted
      expect(game.frames.count).to eq(10)
      expect(game.frames.map(&:number)).to match_array(1..10)
    end
  end
end
