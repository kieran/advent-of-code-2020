# Part Two

As soon as people start to arrive, you realize your mistake. People don't just care about adjacent seats - they care about the first seat they can see in each of those eight directions!

Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those eight directions. For example, the empty seat below would see eight occupied seats:

```plain
.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....
```

The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:

```plain
.............
.L.L.#.#.#.#.
.............
```

The empty seat below would see no occupied seats:

```plain
.##.##.
#.#.#.#
##...##
...L...
##...##
#.#.#.#
.##.##.
```

Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules). The other rules still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never changes.

Given the same starting layout as above, these new rules cause the seating area to shift around as follows:

    input = """
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
    """

```plain
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##

#.LL.LL.L#
#LLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLLL.L
#.LLLLL.L#

#.L#.##.L#
#L#####.LL
L.#.#..#..
##L#.##.##
#.##.#L.##
#.#####.#L
..#.#.....
LLL####LL#
#.L#####.L
#.L####.L#

#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##LL.LL.L#
L.LL.LL.L#
#.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLL#.L
#.L#LL#.L#

#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.#L.L#
#.L####.LL
..#.#.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#

#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.LL.L#
#.LLLL#.LL
..#.L.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
```

Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs, you count 26 occupied seats.

Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?


## Defs

    { flatten } = require 'underscore'

    parseInput = (text='')->
      text
      .split "\n"
      .map (row)->
        row
        .split ''
        .map (val='')->
          switch val
            when '#'
              true
            when 'L'
              false
            when '.'
              null

    logMap = (map=[])->
      ret = map.map (row)->
        row.map (val)->
          switch val
            when true
              '#'
            when false
              'L'
            when null
              '.'

      log row.join '' for row in ret
      null

    nextMap = (map=[])->
      # make a deep copy - no references!
      new_map = JSON.parse JSON.stringify map

      for row, y in map
        for val, x in row
          # skip floor spaces
          continue if val is null

          nv = numVisible y, x, map
          if val is false and nv is 0
            # occupy seat
            new_map[y][x] = true
          else if val is true and nv >= 5
            # vacate seat
            new_map[y][x] = false
      new_map

    # run until stable, then return map
    run = (map=[])->
      new_map = nextMap map
      while JSON.stringify(new_map) isnt JSON.stringify(map)
        map = new_map
        new_map = nextMap map
      new_map

    # how many *visible seats* are occupied
    # - empty seats also block your view of other seats
    numVisible = (y,x,map=[])->
      num = 0
      for dy in [-1, 0, +1]
        for dx in [-1, 0, +1]
          continue if dy is 0 and dx is 0
          search_y = y
          search_x = x
          done = false
          until done
            search_y += dy
            search_x += dx
            switch map[search_y]?[search_x]
              when false      # seat visible, unoccupied
                done = true
              when undefined  # we see the wall
                done = true
              when true       # seat visible, occupied
                num += 1
                done = true
      num

    numOccupiedSeats = (arr=[])->
      flatten arr
      .filter (val)-> !! val
      .length

## Tests

    { log } = console
    assert = require 'assert'

    assert 26 is numOccupiedSeats run parseInput input

## Run

    log numOccupiedSeats run parseInput require './input'
