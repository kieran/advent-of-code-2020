# Day 24: Lobby Layout

Your raft makes it to the tropical island; it turns out that the small crab was an excellent navigator. You make your way to the resort.

As you enter the lobby, you discover a small problem: the floor is being renovated. You can't even reach the check-in desk until they've finished installing the new tile floor.

The tiles are all hexagonal; they need to be arranged in a hex grid with a very specific color pattern. Not in the mood to wait, you offer to help figure out the pattern.

The tiles are all white on one side and black on the other. They start with the white side facing up. The lobby is large enough to fit whatever pattern might need to appear there.

A member of the renovation crew gives you a list of the tiles that need to be flipped over (your puzzle input). Each line in the list identifies a single tile that needs to be flipped by giving a series of steps starting from a reference tile in the very center of the room. (Every line starts from the same reference tile.)

Because the tiles are hexagonal, every tile has six neighbors: east, southeast, southwest, west, northwest, and northeast. These directions are given in your list, respectively, as e, se, sw, w, nw, and ne. A tile is identified by a series of these directions with no delimiters; for example, esenee identifies the tile you land on if you start at the reference tile and then move one tile east, one tile southeast, one tile northeast, and one tile east.

Each time a tile is identified, it flips from white to black or from black to white. Tiles might be flipped more than once. For example, a line like esew flips a tile immediately adjacent to the reference tile, and a line like nwwswee flips the reference tile itself.

Here is a larger example:

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

    tile_key = (x,y,z)-> [x,y,z].join ','

    layTiles = (instr=[], floor={})->
      for dirs in instr
        x = y = z = 0
        for dir in dirs
          [x,y,z] = move x, y, z, dir
        floor[tile_key x, y, z] = not floor[tile_key x, y, z]
      floor

    countFlippedTiles = (floor={}, num=0)->
      num += 1 for t in Object.values floor when t is true
      num


## Tests

    { log } = console
    assert = require 'assert'

    assert 10 is countFlippedTiles layTiles parseInput input

## Run

    log countFlippedTiles layTiles parseInput require './input'
