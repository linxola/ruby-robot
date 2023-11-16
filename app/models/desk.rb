# frozen_string_literal: true

# Class representing a desk on which a robot will walk
class Desk
  def initialize(length, width)
    @length = length
    @width = width
  end

  attr_reader :length, :width
end
