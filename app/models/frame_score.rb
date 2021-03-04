# frozen_string_literal: true

class FrameScore
  attr_reader :number, :score

  def initialize(number:, score:)
    @number = number
    @score = score
  end
end
