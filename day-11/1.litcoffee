# Day 11: Seating System

Your plane lands with plenty of time to spare. The final leg of your journey is a ferry that goes directly to the tropical island where you can finally start your vacation. As you reach the waiting area to board the ferry, you realize you're so early, nobody else has even arrived yet!

By modeling the process people use to choose (or abandon) their seat in the waiting area, you're pretty sure you can predict the best place to sit. You make a quick map of the seat layout (your puzzle input).

The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat (#). For example, the initial seat layout might look like this:

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

Now, you just need to model the people who will be arriving shortly. Fortunately, people are entirely predictable and always follow a simple set of rules. All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat). The following rules are applied to every seat simultaneously:

```plain
If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
Otherwise, the seat's state does not change.
```

Floor (.) never changes; seats don't move, and nobody sits on the floor.

After one round of these rules, every seat in the example layout becomes occupied:

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
```

After a second round, the seats with four or more occupied adjacent seats become empty again:

```plain
#.LL.L#.##
#LLLLLL.L#
L.L.L..L..
#LLL.LL.L#
#.LL.LL.LL
#.LLLL#.##
..L.L.....
#LLLLLLLL#
#.LLLLLL.L
#.#LLLL.##
```

This process continues for three more rounds:

```plain
#.##.L#.##
#L###LL.L#
L.#.#..#..
#L##.##.L#
#.##.LL.LL
#.###L#.##
..#.#.....
#L######L#
#.LL###L.L
#.#L###.##

#.#L.L#.##
#LLL#LL.L#
L.L.L..#..
#LLL.##.L#
#.LL.LL.LL
#.LL#L#.##
..L.L.....
#L#LLLL#L#
#.LLLLLL.L
#.#L#L#.##

#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##
```

At this point, something interesting happens: the chaos stabilizes and further applications of these rules cause no seats to change state! Once people stop moving around, you count 37 occupied seats.

Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?

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

    nextMap = (map=[])->
      # make a deep copy - no references!
      new_map = JSON.parse JSON.stringify map

      for row, y in map
        for val, x in row
          # skip floor spaces
          continue if val is null

          nn = numNeighbours y, x, map
          if val is false and nn is 0
            # occupy seat
            new_map[y][x] = true
          else if val is true and nn >= 4
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

    # how many *adjacent seats* are occupied
    numNeighbours = (y,x,map=[])->
      num = 0
      for dy in [y-1, y, y+1]
        for dx in [x-1, x, x+1]
          continue if dy is y and dx is x
          num += 1 if map[dy]?[dx] or false
      num

    numOccupiedSeats = (arr=[])->
      flatten arr
      .filter (val)-> !! val
      .length

## Tests

    { log } = console
    assert = require 'assert'

    assert 0 is numOccupiedSeats parseInput input
    assert 37 is numOccupiedSeats run parseInput input

## Run

    log numOccupiedSeats run parseInput require './input'
