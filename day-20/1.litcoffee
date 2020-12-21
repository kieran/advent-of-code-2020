# Day 20: Jurassic Jigsaw

The high-speed train leaves the forest and quickly carries you south. You can even see a desert in the distance! Since you have some spare time, you might as well see if there was anything interesting in the image the Mythical Information Bureau satellite captured.

After decoding the satellite messages, you discover that the data actually contains many small images created by the satellite's camera array. The camera array consists of many cameras; rather than produce a single square image, they produce many smaller square image tiles that need to be reassembled back into a single image.

Each camera in the camera array returns a single monochrome image tile with a random unique ID number. The tiles (your puzzle input) arrived in a random order.

Worse yet, the camera array appears to be malfunctioning: each image tile has been rotated and flipped to a random orientation. Your first task is to reassemble the original image by orienting the tiles so they fit together.

To show how the tiles should be reassembled, each tile's image data includes a border that should line up exactly with its adjacent tiles. All tiles have this border, and the border lines up exactly when the tiles are both oriented correctly. Tiles at the edge of the image also have this border, but the outermost edges won't line up with any other tiles.

For example, suppose you have the following nine tiles:

    input = """
      Tile 2311:
      ..##.#..#.
      ##..#.....
      #...##..#.
      ####.#...#
      ##.##.###.
      ##...#.###
      .#.#.#..##
      ..#....#..
      ###...#.#.
      ..###..###

      Tile 1951:
      #.##...##.
      #.####...#
      .....#..##
      #...######
      .##.#....#
      .###.#####
      ###.##.##.
      .###....#.
      ..#.#..#.#
      #...##.#..

      Tile 1171:
      ####...##.
      #..##.#..#
      ##.#..#.#.
      .###.####.
      ..###.####
      .##....##.
      .#...####.
      #.##.####.
      ####..#...
      .....##...

      Tile 1427:
      ###.##.#..
      .#..#.##..
      .#.##.#..#
      #.#.#.##.#
      ....#...##
      ...##..##.
      ...#.#####
      .#.####.#.
      ..#..###.#
      ..##.#..#.

      Tile 1489:
      ##.#.#....
      ..##...#..
      .##..##...
      ..#...#...
      #####...#.
      #..#.#.#.#
      ...#.#.#..
      ##.#...##.
      ..##.##.##
      ###.##.#..

      Tile 2473:
      #....####.
      #..#.##...
      #.##..#...
      ######.#.#
      .#...#.#.#
      .#########
      .###.#..#.
      ########.#
      ##...##.#.
      ..###.#.#.

      Tile 2971:
      ..#.#....#
      #...###...
      #.#.###...
      ##.##..#..
      .#####..##
      .#..####.#
      #..#.#..#.
      ..####.###
      ..#.#.###.
      ...#.#.#.#

      Tile 2729:
      ...#.#.#.#
      ####.#....
      ..#.#.....
      ....#..#.#
      .##..##.#.
      .#.####...
      ####.#.#..
      ##.####...
      ##..#.##..
      #.##...##.

      Tile 3079:
      #.#.#####.
      .#..######
      ..#.......
      ######....
      ####.#..#.
      .#...#.##.
      #.#####.##
      ..#.###...
      ..#.......
      ..#.###...
    """

By rotating, flipping, and rearranging them, you can find a square arrangement that causes all adjacent borders to line up:

```plain
#...##.#.. ..###..### #.#.#####.
..#.#..#.# ###...#.#. .#..######
.###....#. ..#....#.. ..#.......
###.##.##. .#.#.#..## ######....
.###.##### ##...#.### ####.#..#.
.##.#....# ##.##.###. .#...#.##.
#...###### ####.#...# #.#####.##
.....#..## #...##..#. ..#.###...
#.####...# ##..#..... ..#.......
#.##...##. ..##.#..#. ..#.###...

#.##...##. ..##.#..#. ..#.###...
##..#.##.. ..#..###.# ##.##....#
##.####... .#.####.#. ..#.###..#
####.#.#.. ...#.##### ###.#..###
.#.####... ...##..##. .######.##
.##..##.#. ....#...## #.#.#.#...
....#..#.# #.#.#.##.# #.###.###.
..#.#..... .#.##.#..# #.###.##..
####.#.... .#..#.##.. .######...
...#.#.#.# ###.##.#.. .##...####

...#.#.#.# ###.##.#.. .##...####
..#.#.###. ..##.##.## #..#.##..#
..####.### ##.#...##. .#.#..#.##
#..#.#..#. ...#.#.#.. .####.###.
.#..####.# #..#.#.#.# ####.###..
.#####..## #####...#. .##....##.
##.##..#.. ..#...#... .####...#.
#.#.###... .##..##... .####.##.#
#...###... ..##...#.. ...#..####
..#.#....# ##.#.#.... ...##.....
```

For reference, the IDs of the above tiles are:

```plain
1951    2311    3079
2729    1427    2473
2971    1489    1171
```

To check that you've assembled the image correctly, multiply the IDs of the four corner tiles together. If you do this with the assembled tiles from the example above, you get 1951 * 3079 * 2971 * 1171 = 20899048083289.

Assemble the tiles into an image. What do you get if you multiply together the IDs of the four corner tiles?


## Defs

    { uniq } = require 'underscore'

    allTiles = {}

    fingerprint = (str='')->
      parseInt(
        str
        .replace /#/g, '1'
        .replace /\./g, '0'
      , 2)

    rotate = (rows)->
      ret = []
      for idx in [0...rows.length]
        new_row = rows.map (row)-> row[idx]
        ret.push new_row.reverse().join('')
      ret

    flipv = (rows)->
      rows.reverse()

    class Tile
      constructor: (@id, @rows, @r=0, @f=0, @fps={}, @ptf={})->

      @parse: (tileText)->
        [header, rows...] = tileText.split "\n"
        [ id ] = header.match /\d+/
        allTiles[[id,0,0].join('-')] ?= new @ id, rows

      @rotate: (tile)->
        { id, rows, r, f } = tile
        r = (r + 1) % 4
        allTiles[[id,r,f].join('-')] ?= new Tile(id, rotate(rows), r, f)

      @flipv: (tile)->
        { id, rows, r, f } = tile
        f = (f + 1) % 2
        allTiles[[id,r,f].join('-')] ?= new Tile(id, flipv(rows), r, f)

      rotate: -> Tile.rotate @
      flipv: -> Tile.flipv @

      top:    -> @fps['top']    ?= fingerprint @rows[0]
      right:  -> @fps['right']  ?= fingerprint @rows.map((row)-> row[row.length - 1]).join('')
      bottom: -> @fps['bottom'] ?= fingerprint @rows[@rows.length - 1]
      left:   -> @fps['left']   ?= fingerprint @rows.map((row)-> row[0]).join('')

      sides:  -> [@top(), @right(), @bottom(), @left()]

      permutations: (ret=[], tile=@)->
        for fid in [0..1]
          for rid in [0..3]
            ret.push tile
            tile = tile.rotate()
          tile = tile.flipv()
        ret

      fits: (top=null, left=null)->
        top in [null, undefined, @top()] \
        and \
        left in [null, undefined, @left()]

      permsThatFit: (top=null, left=null)->
        @ptf["#{top}-#{left}"] ?= (perm for perm in @permutations() when perm.fits top, left)

      commonSides: (tiles=[])->
        @cs ?= (
          os = []
          for t in tiles when t isnt @
            os = uniq [os..., t.allSides()...]

          count = 0
          count += 1 for s in @allSides() when s in os
          count
        )

      allSides: ->
        @as ?= (
          ret = []
          for p in @permutations()
            ret = [ret..., p.sides()...]
          uniq ret
        )

    parseInput = (text='')->
      allTiles = {}

      text
      .split "\n\n"
      .map (t)-> Tile.parse t

    multArray = (array=[])-> array.reduce (memo=1, val=1)-> memo * val

    cloneMap = (map=[])->
      ret = []
      ret[y] = [map[y]...] for row, y in map
      ret

    blankMap = (w=0)->
      map = []
      for idx in [0...w]
        map[idx] = (null for col in [0...w])
      map

    sort = (tiles=[])->
      tiles.sort (a,b)->
        a.commonSides(tiles) - b.commonSides(tiles)
      tiles

    fillMap = (tiles=[], y=0, x=0, map)->
      return map unless tiles.length
      map ?= blankMap Math.sqrt tiles.length
      top   = map[y-1]?[x]?.bottom?()
      left  = map[y][x-1]?.right?()
      for tile in tiles
        new_tiles = (t for t in tiles when t.id isnt tile.id)
        new_x = (x + 1) % map.length
        new_y = y
        new_y += 1 if new_x is 0
        new_map = cloneMap map
        for perm in tile.permsThatFit top, left
          new_map[y][x] = perm
          return ret if ret = fillMap new_tiles, new_y, new_x, new_map
      return false

    cornerTiles = (map)->
      ret = []
      for y in [0, map.length - 1]
        for x in [0, map.length - 1]
          ret.push map[y][x]

      ret

    idProduct = (tiles=[])->
      multArray(
        tiles
        .map (t)-> t.id
        .map parseFloat
      )

## Tests

    { log } = console
    assert = require 'assert'

    assert 20899048083289 is idProduct cornerTiles fillMap sort parseInput input


## Run

    log idProduct cornerTiles fillMap sort parseInput require './input'
