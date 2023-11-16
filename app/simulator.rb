# frozen_string_literal: true

require_relative 'models/desk'
require_relative 'models/robot'
require 'debug'

# Class representing a toy robot simulator
class Simulator
  def initialize
    puts 'Welcome to the toy robot simulator!'
    puts "In this program you can move your toy robot on a desk, but don't fall!", "\n"
    puts "The commands you should use to manipulate a robot:
          PLACE X,Y,F - sets X, Y position and F direction of a robot on a desk
          (for direction use only this arguments: NORTH, EAST, SOUTH, WEST)\n
          MOVE - moves a robot one cell ahead\n
          LEFT and RIGHT - turn a robot on 90 degrees to the left or right appropriately\n
          REPORT - report robot's position and direction"
    puts 'Enter `EXIT` to exit the program after the desk and robot setup is finished', "\n"
  end

  def run
    @desk = gets_desk_dimensions
    puts "Desk with dimensions #{@desk.length},#{@desk.width} was created"
    @robot = Robot.new

    place_robot

    puts 'Now you can move your robot on the desk with MOVE, LEFT, RIGHT'
    puts "To get robot's position, use REPORT"

    loop do
      input = gets.chomp.upcase
      break if input == 'EXIT'

      move_robot(input)
    end
  end

  private

  def gets_desk_dimensions
    loop do
      puts 'Please enter the X,Y dimensions of the desk ' \
           'or leave empty for default dimensions (default is 5,6)'
      input = gets.chomp
      redo unless dimensions_valid?(input)

      return sets_desk_dimensions(input)
    end
  end

  def dimensions_valid?(input)
    return true if input.empty? || input =~ /^[1-9]+,[1-9]+$/

    puts "\nDimensions Error:\n\tOnly positive integers in the `X,Y` format are allowed!", "\n"
    false
  end

  def sets_desk_dimensions(dimensions_string)
    dimensions = dimensions_string.split(',').map(&:to_i)
    dimensions.empty? ? Desk.new(5, 6) : Desk.new(dimensions[0], dimensions[1])
  end

  def place_robot
    loop do
      puts 'Please set position and direction for the robot on the desk'
      place_params = gets.chomp.upcase
      redo unless place_valid?(place_params)

      place_params = place_params.split(/[\s,']/)
      @robot.set_place(@desk, place_params[1].to_i, place_params[2].to_i, place_params[3])
      break
    rescue Robot::FallError, Robot::DirectionError => e
      puts e.message, "\n"
    end
  end

  def place_valid?(place_params)
    return true if place_params.match(/^PLACE [0-9]+,[0-9]+,[A-Z]+$/)

    puts "\nFormat Error:\n\tEither the PLACE command format is not followed or " \
         'arguments are of the wrong type!'
    puts 'Please note that you must set the position first (with PLACE X,Y,F)', "\n"
    false
  end

  def move_robot(command)
    case command
    when 'MOVE'
      @robot.move
    when 'LEFT'
      @robot.turn_left
    when 'RIGHT'
      @robot.turn_right
    when 'REPORT'
      @robot.report
    else
      puts "\nUnknown command Error:\n\tPlease use only MOVE, LEFT, RIGHT, REPORT commands!", "\n"
    end
  rescue Robot::FallError => e
    puts e.message, "\n"
  end
end

Simulator.new.run if __FILE__ == $PROGRAM_NAME
