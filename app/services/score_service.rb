# frozen_string_literal: true

class ScoreService
  attr_reader :total_score, :frames_score

  def initialize(game_id)
    game = Game.find(game_id)
    @frames = game.frames.order(number: :asc)
    @balls = sorted_balls
    @total_score = 0
  end

  def calculate_score
    @frames_score = @frames.map do |frame|
      frame_score = frame_score(frame)
      @total_score += frame_score

      FrameScore.new(number: frame.number,
                     score: frame_score)
    end
  end

  private

  def sorted_balls
    all_balls = @frames.map { |frame| frame.balls }.flatten
    all_balls.sort_by { |ball| [ball.frame.number, ball.number] }
  end

  def frame_score(frame)
    score = frame.pinfalls
    score += strike_bonus(frame) if frame.strike?
    score += spare_bonus(frame) if frame.spare?

    score
  end

  def strike_bonus(frame)
    next_balls(frame, 2).sum(&:pinfalls)
  end

  def spare_bonus(frame)
    next_balls(frame, 1).sum(&:pinfalls)
  end

  def next_balls(frame, size)
    @balls.select { |ball| ball.frame.number > frame.number }.first(size)
  end
end
