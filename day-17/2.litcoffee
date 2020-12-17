# Part Two

For some reason, your simulated results don't match what the experimental energy source engineers expected. Apparently, the pocket dimension actually has four spatial dimensions, not three.

The pocket dimension contains an infinite 4-dimensional grid. At every integer 4-dimensional coordinate (x,y,z,w), there exists a single cube (really, a hypercube) which is still either active or inactive.

Each cube only ever considers its neighbors: any of the 80 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3,w=4, its neighbors include the cube at x=2,y=2,z=3,w=3, the cube at x=0,y=2,z=3,w=4, and so on.

The initial state of the pocket dimension still consists of a small flat region of cubes. Furthermore, the same rules for cycle updating still apply: during each cycle, consider the number of active neighbors of each cube.

For example, consider the same initial state as in the example above. Even though the pocket dimension is 4-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1x1 region of the 4-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z and w coordinate:

Before any cycles:

    input = """
      .#.
      ..#
      ###
    """

After 1 cycle:

```plain
z=-1, w=-1
#..
..#
.#.

z=0, w=-1
#..
..#
.#.

z=1, w=-1
#..
..#
.#.

z=-1, w=0
#..
..#
.#.

z=0, w=0
#.#
.##
.#.

z=1, w=0
#..
..#
.#.

z=-1, w=1
#..
..#
.#.

z=0, w=1
#..
..#
.#.

z=1, w=1
#..
..#
.#.
```

After 2 cycles:

```plain
z=-2, w=-2
.....
.....
..#..
.....
.....

z=-1, w=-2
.....
.....
.....
.....
.....

z=0, w=-2
###..
##.##
#...#
.#..#
.###.

z=1, w=-2
.....
.....
.....
.....
.....

z=2, w=-2
.....
.....
..#..
.....
.....

z=-2, w=-1
.....
.....
.....
.....
.....

z=-1, w=-1
.....
.....
.....
.....
.....

z=0, w=-1
.....
.....
.....
.....
.....

z=1, w=-1
.....
.....
.....
.....
.....

z=2, w=-1
.....
.....
.....
.....
.....

z=-2, w=0
###..
##.##
#...#
.#..#
.###.

z=-1, w=0
.....
.....
.....
.....
.....

z=0, w=0
.....
.....
.....
.....
.....

z=1, w=0
.....
.....
.....
.....
.....

z=2, w=0
###..
##.##
#...#
.#..#
.###.

z=-2, w=1
.....
.....
.....
.....
.....

z=-1, w=1
.....
.....
.....
.....
.....

z=0, w=1
.....
.....
.....
.....
.....

z=1, w=1
.....
.....
.....
.....
.....

z=2, w=1
.....
.....
.....
.....
.....

z=-2, w=2
.....
.....
..#..
.....
.....

z=-1, w=2
.....
.....
.....
.....
.....

z=0, w=2
###..
##.##
#...#
.#..#
.###.

z=1, w=2
.....
.....
.....
.....
.....

z=2, w=2
.....
.....
..#..
.....
.....
```

After the full six-cycle boot process completes, 848 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles in a 4-dimensional space. How many cubes are left in the active state after the sixth cycle?

## Defs

    parseInput = (text='', iterations=6)->
      # parsing the input map
      arr = text
      .split "\n"
      .map (row)->
        row
        .split ''
        .map (val)->
          val is '#'

      # figuring out how big to make the board
      target_size = arr.length + 3 * iterations
      offset = Math.floor target_size / 2

      # making the blank board
      w = blank_board target_size

      # populate the active cells
      for row, row_idx in arr
        for val, val_idx in row when val
          w[offset][offset][row_idx + offset][val_idx + offset] = true

      # return the board
      w

    blank_board = (target_size)->
      w = new Array target_size
      for z, z_idx in w
        w[z_idx] = new Array target_size
        for y, y_idx in w[z_idx]
          w[z_idx][y_idx] = new Array target_size
          for x, x_idx in w[z_idx][y_idx]
            w[z_idx][y_idx][x_idx] = new Array target_size
            for val, v_idx in w[z_idx][y_idx][x_idx]
              w[z_idx][y_idx][x_idx][v_idx] = false
      w

    cycle = (board=[])->
      next_board = blank_board board.length
      for w, w_idx in board
        for z, z_idx in w
          for y, y_idx in z
            for x, x_idx in y
              active_neighbours = 0
              for w_offset in [-1..1]
                for z_offset in [-1..1]
                  for y_offset in [-1..1]
                    for x_offset in [-1..1]
                      unless w_offset is z_offset is y_offset is x_offset is 0
                        if board[w_idx+w_offset]?[z_idx+z_offset]?[y_idx+y_offset]?[x_idx+x_offset]
                          active_neighbours += 1
              # apply the rules
              if x and active_neighbours in [2,3]
                next_board[w_idx][z_idx][y_idx][x_idx] = true
              if not x and active_neighbours is 3
                next_board[w_idx][z_idx][y_idx][x_idx] = true
      # return the next board
      next_board

    cycles = (num=1, board=[])->
      board = cycle board for i in [0...num]
      board

    num_active = (board=[])->
      active = 0
      for w in board
        for z in w
          for y in z
            for x in y when x
              active += 1
      active


## Tests

    { log } = console
    assert = require 'assert'

    assert 5 is num_active parseInput input
    assert 29 is num_active cycles 1, parseInput input
    # assert 848 is num_active cycles 6, parseInput input


## Run

    log num_active cycles 6, parseInput require './input'
