# Part Two
Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

```
Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.
```

In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?


## Defs

    { log, table } = console
    assert = require 'assert'


    treeMap = (text)->
      text.split("\n").map (line)->
        line.split('').map (char)->
          char is '#'

    isTree = (y, x, map)->
      width = map[0].length
      map[y][x % width]

    treesHit = (y_offset=1, x_offset=3, map)->
      y = x = trees = 0
      until y+y_offset >= map.length
        y += y_offset
        x += x_offset
        trees += 1 if isTree y, x, map
      trees

    productOfTreesHit = (slopes, map)->
      slopes
      .map (slope)->
        [ x, y ] = slope
        treesHit y, x, map
      .reduce (memo=1, val)->
        memo * val


## Tests

    input = """
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
    """

    slopes = [
      [1,1]
      [3,1]
      [5,1]
      [7,1]
      [1,2]
    ]

    map = treeMap input

    assert not isTree 1, 3, map
    assert     isTree 2, 6, map
    assert not isTree 3, 9, map
    assert     isTree 4, 12, map
    assert     isTree 5, 15, map
    assert not isTree 6, 18, map

    assert 7 is treesHit 1, 3, map

    assert 336 is productOfTreesHit slopes, map

## Run

    input = require './input'

    log productOfTreesHit slopes, treeMap input
