# Conway Cubes

As your flight slowly drifts through the sky, the Elves at the Mythical Information Bureau at the North Pole contact you. They'd like some help debugging a malfunctioning experimental energy source aboard one of their super-secret imaging satellites.

The experimental energy source is based on cutting-edge technology: a set of Conway Cubes contained in a pocket dimension! When you hear it's having problems, you can't help but agree to take a look.

The pocket dimension contains an infinite 3-dimensional grid. At every integer 3-dimensional coordinate (x,y,z), there exists a single cube which is either active or inactive.

In the initial state of the pocket dimension, almost all cubes start inactive. The only exception to this is a small flat region of cubes (your puzzle input); the cubes in this region start in the specified active (#) or inactive (.) state.

The energy source then proceeds to boot up by executing six cycles.

Each cube only ever considers its neighbors: any of the 26 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3, its neighbors include the cube at x=2,y=2,z=2, the cube at x=0,y=2,z=3, and so on.

During a cycle, all cubes simultaneously change their state according to the following rules:

```plain
If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
```

The engineers responsible for this experimental energy source would like you to simulate the pocket dimension and determine what the configuration of cubes should be at the end of the six-cycle boot process.

For example, consider the following initial state:

    input = """
      .#.
      ..#
      ###
    """

Even though the pocket dimension is 3-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1 region of the 3-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z coordinate (and the frame of view follows the active cells in each cycle):

Before any cycles:

```plain
z=0
.#.
..#
###
```

After 1 cycle:

```plain
z=-1
#..
..#
.#.

z=0
#.#
.##
.#.

z=1
#..
..#
.#.
```

After 2 cycles:

```plain
z=-2
.....
.....
..#..
.....
.....

z=-1
..#..
.#..#
....#
.#...
.....

z=0
##...
##...
#....
....#
.###.

z=1
..#..
.#..#
....#
.#...
.....

z=2
.....
.....
..#..
.....
.....
```

After 3 cycles:

```plain
z=-2
.......
.......
..##...
..###..
.......
.......
.......

z=-1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=0
...#...
.......
#......
.......
.....##
.##.#..
...#...

z=1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=2
.......
.......
..##...
..###..
.......
.......
.......
```

After the full six-cycle boot process completes, 112 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state after the sixth cycle?

## Defs

```plain
.#.
..#
###
```

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
      target_size = arr.length + 2 * iterations
      offset = Math.floor target_size / 2

      # making the blank board
      z = new Array target_size
      for layer, idx in z
        z[idx] = new Array target_size
        for row, r_idx in z[idx]
          z[idx][r_idx] = new Array target_size

      # populate the active cells
      for row, row_idx in arr
        for val, val_idx in row when val
          z[offset][row_idx + offset][val_idx + offset] = true

      # return the board
      z

    cycle = (board=[])->
      new_board = JSON.parse JSON.stringify board
      for z, z_idx in new_board
        for y, y_idx in z
          for x, x_idx in y
            active_neighbours = 0
            for z_offset in [-1..1]
              for y_offset in [-1..1]
                for x_offset in [-1..1]
                  continue if z_idx is y_idx is x_idx is 0
                  active_neighbours += 1 if board[z_idx+z_offset]?[y_idx+y_offset]?[x_idx+x_offset]
            # log z_idx, y_idx, x_idx, active_neighbours if active_neighbours > 0
            if x and active_neighbours not in [2,3]
              new_board[z_idx][y_idx][x_idx] = false
            else if active_neighbours is 3
              new_board[z_idx][y_idx][x_idx] = true
      new_board

    cycles = (num=1, board=[])->
      for i in [0...num]
        board = cycle board
      board

    num_active = (board=[])->
      active = 0
      for z, z_idx in board
        for y, y_idx in z
          for x, x_idx in y when x
            active += 1
      active



If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.



## Tests

    { log } = console
    assert = require 'assert'

    board = parseInput input
    assert 11 is num_active cycles 1, board
    assert 21 is num_active cycles 2, board
    log num_active cycles 3, board
    # assert 71 is num_active cycles 6, board






## Run

