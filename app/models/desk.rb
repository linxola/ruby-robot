# frozen_string_literal: true

# Class representing the desk
class Desk
  class DimensionsError < StandardError; end

  def initialize(length = 5, width = 6)
    @length = length
    @width = width
    validate_dimensions
  end

  attr_reader :length, :width

  private

  def validate_dimensions
    return unless [@length, @width].any? { |value| value < 1 }

    raise DimensionsError, 'Dimensions error: A desk cannot have such dimensions!'
  end
end
