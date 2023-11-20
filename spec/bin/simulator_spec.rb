# frozen_string_literal: true

require_relative '../../lib/desk'
require_relative '../../lib/robot'
require_relative '../../bin/simulator'

# rubocop: disable RSpec/ExampleLength, RSpec/SubjectStub
RSpec.describe Simulator do
  subject(:simulator) { described_class.new }

  context 'when all the commands were inputed right' do
    context 'when desk dimensions are passed' do
      it 'does not display any errors or warnings' do
        allow(simulator).to receive(:gets)
          .and_return('2,3', 'PLACE 1,2,EAST', 'MOVE', 'LEFT', 'RIGHT', 'REPORT', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 2,3 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n" \
            "Robot's coordinates are 2,2 and it looks EAST\n"
          ).to_stdout
      end
    end

    context 'when desk dimensions are kept default' do
      it 'does not display any errors or warnings' do
        allow(simulator).to receive(:gets)
          .and_return('', 'PLACE 1,2,EAST', 'MOVE', 'LEFT', 'RIGHT', 'REPORT', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 5,6 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n" \
            "Robot's coordinates are 2,2 and it looks EAST\n"
          ).to_stdout
      end
    end
  end

  context 'when desk dimensions are passed wrong' do
    it 'displays Dimensions Error' do
      allow(simulator).to receive(:gets)
        .and_return('2 3', '', 'PLACE 1,2,EAST', 'EXIT')

      expect { simulator.run }
        .to output(
          'Please enter the X,Y dimensions of the desk ' \
          "or leave empty for default dimensions (default is 5,6)\n" \
          "\nDimensions Error:\n\tOnly positive integers in the `X,Y` format are allowed!\n" \
          "\nPlease enter the X,Y dimensions of the desk " \
          "or leave empty for default dimensions (default is 5,6)\n" \
          "Desk with dimensions 5,6 was created\n" \
          "Please set position and direction for the robot on the desk\n" \
          "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
          "To get robot's position, use REPORT\n"
        ).to_stdout
    end
  end

  context 'when robot place command is entered wrong' do
    context 'when format of PLACE command is wrong / trying to enter other commands before PLACE' do
      it 'displays Format Error' do
        allow(simulator).to receive(:gets)
          .and_return('', 'PLACE 1 3 EAST', 'PLACE 1,2,EAST', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 5,6 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "\nFormat Error:\n\tEither the PLACE command format is not followed or " \
            "arguments are of the wrong type!\n" \
            "Please note that you must set the position first (with PLACE X,Y,F)\n" \
            "\nPlease set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n"
          ).to_stdout
      end

      it 'also displays Format Error' do
        allow(simulator).to receive(:gets)
          .and_return('', 'MOVE', 'PLACE 1,2,EAST', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 5,6 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "\nFormat Error:\n\tEither the PLACE command format is not followed or " \
            "arguments are of the wrong type!\n" \
            "Please note that you must set the position first (with PLACE X,Y,F)\n" \
            "\nPlease set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n"
          ).to_stdout
      end
    end

    context 'when placement coordinates are out of the desk' do
      it 'displays Fall Warning' do
        allow(simulator).to receive(:gets)
          .and_return('', 'PLACE 100,50,EAST', 'PLACE 1,2,EAST', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 5,6 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "\nFall Warning:\n\tThe robot will fall with such a move!\n" \
            "\nPlease set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n"
          ).to_stdout
      end
    end

    context 'when entered placement direction is wrong' do
      it 'displays Direction Error' do
        allow(simulator).to receive(:gets)
          .and_return('', 'PLACE 1,3,SOMEWHERE', 'PLACE 1,2,EAST', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 5,6 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "\nDirection Error:\n\tThe direction entered is unknown " \
            "please use NORTH, EAST, SOUTH or WEST\n" \
            "\nPlease set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n"
          ).to_stdout
      end
    end
  end

  context 'when moving robot wrong' do
    context 'when entering unknown command' do
      it 'displays Unknown command Error' do
        allow(simulator).to receive(:gets)
          .and_return('2,3', 'PLACE 1,2,EAST', 'STEP', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 2,3 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n" \
            "\nUnknown command Error:\n\tPlease use only MOVE, LEFT, RIGHT, REPORT commands!\n\n"
          ).to_stdout
      end
    end

    context 'when trying to move out of a desk' do
      it 'displays Fall Warning' do
        allow(simulator).to receive(:gets)
          .and_return('2,3', 'PLACE 2,2,EAST', 'MOVE', 'EXIT')

        expect { simulator.run }
          .to output(
            'Please enter the X,Y dimensions of the desk ' \
            "or leave empty for default dimensions (default is 5,6)\n" \
            "Desk with dimensions 2,3 was created\n" \
            "Please set position and direction for the robot on the desk\n" \
            "Now you can move your robot on the desk with MOVE, LEFT, RIGHT\n" \
            "To get robot's position, use REPORT\n" \
            "\nFall Warning:\n\tThe robot will fall with such a move!\n\n"
          ).to_stdout
      end
    end
  end
end
# rubocop: enable RSpec/ExampleLength, RSpec/SubjectStub
