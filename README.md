# Toy robot simulator

This CLI program is a simple toy robot simulator written in Ruby.

## Description

 - Toy robot moves on a rectangular desk with dimensions X x Y cells. If no size is given, the size is set to 5 x 6 cells
 - There are no more obstacles on a desk
 - A robot moves freely on a desk, but it avoids falling off a desk. Any command that could cause a robot to fall off a desk is avoided (skipped), but any subsequent commands that do not cause a robot to fall are executed

## Technical side

 - Application reads commands of the following form:
   PLACE X, Y, F
   MOVE
   LEFT
   RIGHT
   REPORT

 - The size of a desk is set when the application is initialized
 - PLACE sets the position of a robot on a desk with the coordinates of a cell (X, Y) and the direction a robot will face (F) - NORTH, SOUTH, EAST or WEST
 - The cell with coordinates 0,0 is considered as the uttermost southwest corner (SOUTH WEST)
 - The very first valid command for a robot must be a PLACE command. The application will reject all commands in the sequence until the PLACE command is executed
 - MOVE - moves a robot one cell forward in the direction it is currently facing
 - LEFT and RIGHT - rotates a robot 90 degrees in the corresponding direction without changing its position
 - REPORT - outputs robot's current coordinates (X, Y) and its current direction (F)

 - A robot that is not on a desk ignores the MOVE, LEFT, RIGHT and REPORT commands 
 - Data input can be either from a file or from the command line
 - There are also test data for verification in the form of RSpec tests present

## Input and Output examples

a)
PLACE 0,0,NORTH \
MOVE \
REPORT \
->Robot's coordinates are 0,1 and it looks NORTH

b)
PLACE 0,0,NORTH \
LEFT \
REPORT \
->Robot's coordinates are 0,0 and it looks WEST

c)
PLACE 1,2,EAST \
MOVE \
MOVE \
LEFT \
MOVE \
REPORT \
->Robot's coordinates are 3,3 and it looks NORTH

