# frozen_string_literal: true

class GameService
  attr_reader :game

  def initialize(game_id)
    @game = Game.find(game_id)
  end

  def self.create_with_initial_state!
    game = Game.new
    game.frames = (1..10).map do |number|
      Frame.new(number: number)
    end
    game.save!

    game
  end

  def add_pinfalls!(frame_number:, ball_number:, pinfalls:)
    @current_frame = game.frames.find_by!(number: frame_number)
    @pinfalls = pinfalls
    @ball_number = ball_number
    
    validate!

    @current_frame.balls << Ball.new(number: ball_number, pinfalls: pinfalls)
  end

  private

  def validate!
    validate_pinfalls_range!
    validate_pinfalls_per_frame!
    validate_ball_number!
    validate_skip_frame!
    validate_frame_completed!
  end

  def validate_pinfalls_per_frame!
    if @current_frame.pinfalls + @pinfalls > 10
      raise GameInvalidError, 'max pinfalls for frame is 10'
    end
  end

  def validate_pinfalls_range!
    unless (0..10).include?(@pinfalls)
      raise GameInvalidError, 'pinfalls must be a number between 0 and 10'
    end
  end

  def validate_ball_number!
    existing_numbers = @current_frame.balls.map(&:number)
    previous_ball_number = @ball_number - 1

    if previous_ball_number > 0 && existing_numbers.exclude?(previous_ball_number)
      raise GameInvalidError, 'can\'t skip a ball_number'
    end
  end

  def validate_skip_frame!
    previous_frame = @game.frames.find_by(number: @current_frame.number - 1)

    if previous_frame.present? && !previous_frame.complete?
      raise GameInvalidError, 'can\'t skip a frame'
    end
  end

  def validate_frame_completed!
    if @current_frame.complete?
      raise GameInvalidError, 'frame already completed'
    end
  end
end
