# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameService do
  describe '#add_pinfall' do
    context 'when number of pinfalls is out of range' do
      it 'raises an exception' do
        game = described_class.create_with_initial_state!
        game_service = described_class.new(game.id)

        expect { game_service.add_pinfalls!(frame_number: 1, ball_number: 1, pinfalls: 11) }.to raise_error(GameInvalidError)
      end
    end

    context 'when a ball_number is skipped' do
      it 'raises an exception' do
        game = described_class.create_with_initial_state!
        game_service = described_class.new(game.id)

        expect { game_service.add_pinfalls!(frame_number: 1, ball_number: 2, pinfalls: 7) }.to raise_error(GameInvalidError)
      end
    end

    context 'when skiping a frame' do
      it 'raises an exception' do
        game = described_class.create_with_initial_state!
        game_service = described_class.new(game.id)

        expect { game_service.add_pinfalls!(frame_number: 2, ball_number: 1, pinfalls: 7) }.to raise_error(GameInvalidError)
      end
    end

    context 'when frame is already complete' do
      it 'raises an exception' do
        game = described_class.create_with_initial_state!
        game_service = described_class.new(game.id)
        game_service.add_pinfalls!(frame_number: 1, ball_number: 1, pinfalls: 10)

        expect { game_service.add_pinfalls!(frame_number: 1, ball_number: 2, pinfalls: 7) }.to raise_error(GameInvalidError)
      end
    end

    context 'when exceding the max number of pins' do
      it 'raises an exception' do
        game = described_class.create_with_initial_state!
        game_service = described_class.new(game.id)
        game_service.add_pinfalls!(frame_number: 1, ball_number: 1, pinfalls: 9)

        expect { game_service.add_pinfalls!(frame_number: 1, ball_number: 2, pinfalls: 2) }.to raise_error(GameInvalidError)

      end
    end

    context 'when valid' do
      it 'persists the ball with the pinfalls' do
        game = described_class.create_with_initial_state!
        game_service = described_class.new(game.id)

        game_service.add_pinfalls!(frame_number: 1, ball_number: 1, pinfalls: 8)

        frame = game.frames.find_by(number: 1)

        expect(frame.balls.count).to eq(1)
        expect(frame.balls.first.pinfalls).to eq(8)
      end
    end
  end

  describe '.create_with_initial_state!' do
    it 'creates the game with all 10 frames' do
      game = described_class.create_with_initial_state!

      expect(game).to be_persisted
      expect(game.frames.count).to eq(10)
      expect(game.frames.map(&:number)).to match_array(1..10)
    end
  end
end
