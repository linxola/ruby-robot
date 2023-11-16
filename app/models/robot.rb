# frozen_string_literal: true

# Class representing a robot that will walk on a desk
class Robot
  class FallError < StandardError; end
  class DirectionError < StandardError; end

  DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze

  def initialize
    @desk = nil
    @x_coord = nil
    @y_coord = nil
    @direction = nil
  end

  attr_reader :desk, :x_coord, :y_coord, :direction

  def set_place(desk, x_coord, y_coord, direction)
    validate_coordinates(x_coord, y_coord, desk)
    validate_direction(direction)

    @desk = desk
    @x_coord = x_coord
    @y_coord = y_coord
    @direction = direction
  end

  def move
    case @direction
    when 'NORTH'
      validate_coordinates(@x_coord, @y_coord + 1)
      @y_coord += 1
    when 'EAST'
      validate_coordinates(@x_coord + 1, @y_coord)
      @x_coord += 1
    when 'SOUTH'
      validate_coordinates(@x_coord, @y_coord - 1)
      @y_coord -= 1
    when 'WEST'
      validate_coordinates(@x_coord - 1, @y_coord)
      @x_coord -= 1
    end
  end

  def turn_left
    new_direction = DIRECTIONS.index(@direction) - 1
    @direction = new_direction.negative? ? DIRECTIONS[-1] : DIRECTIONS[new_direction]
  end

  def turn_right
    new_direction = DIRECTIONS.index(@direction) + 1
    @direction = new_direction > 3 ? DIRECTIONS[0] : DIRECTIONS[new_direction]
  end

  def report
    puts "Robot's coordinates are #{@x_coord}, #{@y_coord} and it looks #{@direction}"
  end

  private

  def validate_coordinates(x_coord, y_coord, desk = @desk)
    if [x_coord, y_coord].any?(&:negative?) || x_coord > desk.length || y_coord > desk.width
      raise FallError, 'Fall warning: The robot will fall with such a move!'
    end
  end

  def validate_direction(direction)
    return if DIRECTIONS.include?(direction)

    raise DirectionError, 'Direction error: The direction entered is unknown,
                           please use NORTH, EAST, SOUTH or WEST'
  end
end
