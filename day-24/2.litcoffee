# Part Two

The tile floor in the lobby is meant to be a living art exhibit. Every day, the tiles are all flipped according to the following rules:

1. Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
2. Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.

Here, tiles immediately adjacent means the six tiles directly touching the tile in question.

The rules are applied simultaneously to every tile; put another way, it is first determined which tiles need to be flipped, then they are all flipped at the same time.

In the above example, the number of black tiles that are facing up after the given number of days has passed is as follows:

```plain
Day 1: 15
Day 2: 12
Day 3: 25
Day 4: 14
Day 5: 23
Day 6: 28
Day 7: 41
Day 8: 37
Day 9: 49
Day 10: 37

Day 20: 132
Day 30: 259
Day 40: 406
Day 50: 566
Day 60: 788
Day 70: 1106
Day 80: 1373
Day 90: 1844
Day 100: 2208
```

After executing this process a total of 100 times, there would be 2208 black tiles facing up.

How many tiles will be black after 100 days?


In the above example, 10 tiles are flipped once (to black), and 5 more are flipped twice (to black, then back to white). After all of these instructions have been followed, a total of 10 tiles are black.


Go through the renovation crew's list and determine which tiles they need to flip. After all of the instructions have been followed, how many tiles are left with the black side up?

## Defs

    parseInput = (text='')->
      text
      .split "\n"
      .map (line)->
        line.match /(se|sw|ne|nw|e|w)/g

    # see https://www.redblobgames.com/grids/hexagons/#coordinates-cube
    move = (x=0,y=0,z=0,dir)->
      switch dir
        when 'w'
          x -= 1
          y += 1
        when 'e'
          x += 1
          y -= 1

        when 'nw'
          z -= 1
          y += 1
        when 'se'
          z += 1
          y -= 1

        when 'sw'
          x -= 1
          z += 1
        when 'ne'
          x += 1
          z -= 1

      [x,y,z]

    tile_key = (x,y,z)->
      [x,y,z].join ','

    layTiles = (instr=[], floor={})->
      for dirs in instr
        x = y = z = 0
        for dir in dirs
          [x,y,z] = move x, y, z, dir
        floor[tile_key x, y, z] = not floor[tile_key x, y, z]
      floor

    count_neighbours = (floor={}, x=0, y=0, z=0, sum=0)->
      for dir in 'w e sw se nw ne'.split ' '
        [nx, ny, nz] = move x, y, z, dir
        sum += 1 if floor[tile_key nx, ny, nz]
      sum

    flipFloor = (floor={}, newFloor={})->
      for key, val of floor when val
        [x,y,z] = key.split(',').map parseFloat

        for dir in 'w e sw se nw ne'.split ' '
          [nx, ny, nz] = move x, y, z, dir

          cur = floor[tile_key nx, ny, nz]
          num_bt = count_neighbours floor, nx, ny, nz
          if cur
            if num_bt not in [1,2]
              newFloor[tile_key nx, ny, nz] = false
            else
              newFloor[tile_key nx, ny, nz] = true
          if not cur and num_bt is 2
            newFloor[tile_key nx, ny, nz] = true
      newFloor

    countFlippedTiles = (floor={}, num=0)->
      num += 1 for t in Object.values floor when t is true
      num

    iterate_floor = (times=0, floor={})->
      for i in [0...times]
        floor = flipFloor floor
      floor


## Tests

    input = """
      sesenwnenenewseeswwswswwnenewsewsw
      neeenesenwnwwswnenewnwwsewnenwseswesw
      seswneswswsenwwnwse
      nwnwneseeswswnenewneswwnewseswneseene
      swweswneswnenwsewnwneneseenw
      eesenwseswswnenwswnwnwsewwnwsene
      sewnenenenesenwsewnenwwwse
      wenwwweseeeweswwwnwwe
      wsweesenenewnwwnwsenewsenwwsesesenwne
      neeswseenwwswnwswswnw
      nenwswwsewswnenenewsenwsenwnesesenew
      enewnwewneswsewnwswenweswnenwsenwsw
      sweneswneswneneenwnewenewwneswswnese
      swwesenesewenwneswnwwneseswwne
      enesenwswwswneneswsenwnewswseenwsese
      wnwnesenesenenwwnenwsewesewsesesew
      nenewswnwewswnenesenwnesewesw
      eneswnwswnwsenenwnwnwwseeswneewsenese
      neswnwewnwnwseenwseesewsenwsweewe
      wseweeenwnesenwwwswnew
    """

    { log } = console
    assert = require 'assert'

    assert 2208 is countFlippedTiles iterate_floor 100, layTiles parseInput input

## Run

    log countFlippedTiles iterate_floor 100, layTiles parseInput require './input'
