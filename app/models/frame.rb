class Frame < ApplicationRecord
  belongs_to :game
  has_many :balls, dependent: :destroy

  def strike?
    balls.find_by(number: 1)&.pinfalls == 10
  end

  def spare?
    first_two_balls = balls.where(number: [1, 2])
    pinfalls = first_two_balls.map(&:pinfalls)

    pinfalls.sum == 10 && pinfalls.exclude?(10)
  end

  def pinfalls(max_balls=3)
    balls_to_sum = balls.where(number: (1..max_balls))
    balls_to_sum.pluck(:pinfalls).sum
  end

  def complete?
    return true if balls.count == 2 && !last_frame?
    return true if balls.count == 3
    return true if finished_by_strike?

    return false if balls.count <= 1 && !finished_by_strike?
    return false if balls.count == 2 && !finished_by_spare?
  end

  private

  def finished_by_strike?
    strike? && !last_frame?
  end

  def last_frame?
    number == 10
  end

  def finished_by_spare?
    spare? && balls.count == 2 && !last_frame?
  end
end
