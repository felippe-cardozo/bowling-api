# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoreService do
  describe '#calculate_score' do
    context 'when game is perfect' do
      it 'returns the max score, that is 300' do
        perfect_game = GameService.create_with_initial_state!

        perfect_game.frames.each { |frame| frame.balls << Ball.new(number: 1, pinfalls: 10) }
        last_frame = perfect_game.frames.find_by(number: 10)

        last_frame.balls << Ball.new(number: 2, pinfalls: 10)
        last_frame.balls << Ball.new(number: 3, pinfalls: 10)

        service = described_class.new(perfect_game.id)
        service.calculate_score

        expect(service.total_score).to eq(300)
      end
    end

    context 'when dealing with a spare' do
      it 'adds the next pinfall to the score of the spare frame' do
        game = GameService.create_with_initial_state!
        first_frame = game.frames.find_by(number: 1)
        second_frame = game.frames.find_by(number: 2)
        
        first_frame.balls << Ball.new(number: 1, pinfalls: 9)
        first_frame.balls << Ball.new(number: 2, pinfalls: 1)
        second_frame.balls << Ball.new(number: 1, pinfalls: 1)
        second_frame.balls << Ball.new(number: 2, pinfalls: 7)

        service = described_class.new(game.id)
        service.calculate_score

        expect(service.total_score).to eq(19)
      end
    end

    context 'when game has no pinfalls yet' do
      it 'has 0 total_score' do
        game = GameService.create_with_initial_state!
        service = described_class.new(game.id)

        service.calculate_score

        expect(service.total_score).to eq(0)
      end
    end
  end
end
