# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frames, dependent: :destroy
end
