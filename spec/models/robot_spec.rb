# frozen_string_literal: true

require_relative '../../app/models/robot'

RSpec.describe Robot do
  subject(:robot) { described_class.new }

  describe 'constants' do
    it 'has constant DIRECTIONS' do
      expect(Robot::DIRECTIONS).to eq(%w[NORTH EAST SOUTH WEST])
    end
  end

  context 'when creating a robot' do
    it 'creates with nil attributes' do
      expect(robot).to have_attributes(desk: nil, x_coord: nil, y_coord: nil, direction: nil)
    end
  end

  describe '#set_place' do
    let(:desk) { Desk.new(6, 9) }

    context 'with valid arguments' do
      it 'changes robot attributes to passed values' do
        expect { robot.set_place(desk, 3, 4, 'EAST') }.to change(robot, :desk).to(desk)
                                                      .and change(robot, :x_coord).to(3)
                                                      .and change(robot, :y_coord).to(4)
                                                      .and change(robot, :direction).to('EAST')
      end
    end

    context 'with invalid coordinate' do
      it 'raises fall warning' do
        expect { robot.set_place(desk, 8, 4, 'EAST') }.to raise_error(Robot::FallError)
      end
    end

    context 'with invalid direction' do
      it 'raises direction error' do
        expect { robot.set_place(desk, 3, 4, 'straight') }.to raise_error(Robot::DirectionError)
      end
    end
  end

  describe '#move' do
    let(:desk) { Desk.new(6, 9) }

    context 'when moving in the borders of the desk' do
      it 'moves robot one step ahead with NORTH direction' do
        robot.set_place(desk, 3, 4, 'NORTH')
        expect { robot.move }.to change(robot, :y_coord).from(4).to(5)
      end

      it 'moves robot one step ahead with EAST direction' do
        robot.set_place(desk, 3, 4, 'EAST')
        expect { robot.move }.to change(robot, :x_coord).from(3).to(4)
      end

      it 'moves robot one step ahead with SOUTH direction' do
        robot.set_place(desk, 3, 4, 'SOUTH')
        expect { robot.move }.to change(robot, :y_coord).from(4).to(3)
      end

      it 'moves robot one step ahead with WEST direction' do
        robot.set_place(desk, 3, 4, 'WEST')
        expect { robot.move }.to change(robot, :x_coord).from(3).to(2)
      end
    end

    context 'when moving out the borders of the desk' do
      it 'raises fall error when NORTH direction on the north border' do
        robot.set_place(desk, 3, 9, 'NORTH')
        expect { robot.move }.to raise_error(Robot::FallError)
      end

      it 'raises fall error when EAST direction on the east border' do
        robot.set_place(desk, 6, 4, 'EAST')
        expect { robot.move }.to raise_error(Robot::FallError)
      end

      it 'raises fall error when SOUTH direction on the south border' do
        robot.set_place(desk, 3, 0, 'SOUTH')
        expect { robot.move }.to raise_error(Robot::FallError)
      end

      it 'raises fall error when WEST direction on the west border' do
        robot.set_place(desk, 0, 4, 'WEST')
        expect { robot.move }.to raise_error(Robot::FallError)
      end
    end
  end

  describe '#turn_left' do
    let(:desk) { Desk.new(6, 9) }

    it 'turnes robot from NORTH to WEST direction' do
      robot.set_place(desk, 3, 4, 'NORTH')
      expect { robot.turn_left }.to change(robot, :direction).from('NORTH').to('WEST')
    end

    it 'turnes robot from EAST to NORTH direction' do
      robot.set_place(desk, 3, 4, 'EAST')
      expect { robot.turn_left }.to change(robot, :direction).from('EAST').to('NORTH')
    end

    it 'turnes robot from SOUTH to EAST direction' do
      robot.set_place(desk, 3, 4, 'SOUTH')
      expect { robot.turn_left }.to change(robot, :direction).from('SOUTH').to('EAST')
    end

    it 'turnes robot from WEST to SOUTH direction' do
      robot.set_place(desk, 3, 4, 'WEST')
      expect { robot.turn_left }.to change(robot, :direction).from('WEST').to('SOUTH')
    end
  end

  describe '#turn_right' do
    let(:desk) { Desk.new(6, 9) }

    it 'turnes robot from NORTH to EAST direction' do
      robot.set_place(desk, 3, 4, 'NORTH')
      expect { robot.turn_right }.to change(robot, :direction).from('NORTH').to('EAST')
    end

    it 'turnes robot from EAST to SOUTH direction' do
      robot.set_place(desk, 3, 4, 'EAST')
      expect { robot.turn_right }.to change(robot, :direction).from('EAST').to('SOUTH')
    end

    it 'turnes robot from SOUTH to WEST direction' do
      robot.set_place(desk, 3, 4, 'SOUTH')
      expect { robot.turn_right }.to change(robot, :direction).from('SOUTH').to('WEST')
    end

    it 'turnes robot from WEST to NORTH direction' do
      robot.set_place(desk, 3, 4, 'WEST')
      expect { robot.turn_right }.to change(robot, :direction).from('WEST').to('NORTH')
    end
  end

  describe '#report' do
    let(:desk) { Desk.new(6, 9) }

    before { robot.set_place(desk, 3, 4, 'EAST') }

    it "prints robot's coordinates and its direction" do
      expect { robot.report }
        .to output("Robot's coordinates are 3, 4 and it looks EAST\n").to_stdout
    end
  end
end
