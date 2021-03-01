# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frames, dependent: :destroy

  def self.create_with_initial_state!
    game = new
    game.frames = (1..10).map do |number|
      Frame.new(number: number)
    end
    game.save!

    game
  end
end
