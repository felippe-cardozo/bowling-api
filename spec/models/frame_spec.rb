# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame do
  describe '#strike?' do
    context 'when frame has one ball and 10 pinfalls' do
      it 'returns true' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 10)

        expect(frame.strike?).to be true
      end
    end
  end

  describe '#pinfalls' do
    it 'returns the sum of pinfalls from all balls' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 9)
        frame.balls.create(number: 2, pinfalls: 1)

        expect(frame.pinfalls).to eq(10)
    end

    context 'when there are no balls yet' do
      it 'returns 0' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)

        expect(frame.pinfalls).to eq(0)
      end
    end

    context 'when setting the max_balls param' do
      it 'only sum\'s until that ball number' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 9)
        frame.balls.create(number: 2, pinfalls: 1)

        expect(frame.pinfalls(max_balls=1)).to eq(9)
      end
    end
  end

  describe '#spare?' do
    context 'when frame has one ball' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 10)

        expect(frame.spare?).to be false
      end
    end
    context 'when frame\'s first two balls sum 10, and no ball has 10 pinfalls' do
      it 'returns true' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 9)
        frame.balls.create(number: 1, pinfalls: 1)

        expect(frame.spare?).to be true
      end
    end
  end
  describe '#complete?' do
    context 'when the frame has no balls' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)

        expect(frame.complete?).to be false
      end
    end

    context 'when the frame has only one ball and it\'s not a strike' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 9)

        expect(frame.complete?).to be false
      end
    end

    context 'when the frame has only one ball and it\'s a strike' do
      it 'returns true' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 1)
        frame.balls.create(number: 1, pinfalls: 10)

        expect(frame.complete?).to be true
      end
    end

    context 'when the frame has only one ball, it\'s a strike, but it\'s the last frame' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 10)
        frame.balls.create(number: 1, pinfalls: 10)

        expect(frame.complete?).to be false
      end
    end

    context 'when it\'s the last frame, with two balls, and it\'s a spare' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 10)
        frame.balls.create(number: 1, pinfalls: 1)
        frame.balls.create(number: 2, pinfalls: 9)

        expect(frame.complete?).to be false
      end
    end

    context 'when it\'s the last frame, with two balls, and first ball was a strike' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 10)
        frame.balls.create(number: 1, pinfalls: 10)
        frame.balls.create(number: 2, pinfalls: 9)

        expect(frame.complete?).to be false
      end
    end
    context 'when it\'s the last frame, with one balls, and it\'s a strike' do
      it 'returns false' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 10)
        frame.balls.create(number: 1, pinfalls: 10)

        expect(frame.complete?).to be false
      end
    end

    context 'when it\'s not the last frame and has two balls' do
      it 'returns true' do
        game = Game.create_with_initial_state!
        frame = game.frames.find_by(number: 9)
        frame.balls.create(number: 1, pinfalls: 5)
        frame.balls.create(number: 1, pinfalls: 4)

        expect(frame.complete?).to be true
      end
    end
  end
end
