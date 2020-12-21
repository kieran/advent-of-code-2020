# Part Two

Now, you're ready to check the image for sea monsters.

The borders of each tile are not part of the actual image; start by removing them.

In the example above, the tiles become:

```plain
.#.#..#. ##...#.# #..#####
###....# .#....#. .#......
##.##.## #.#.#..# #####...
###.#### #...#.## ###.#..#
##.#.... #.##.### #...#.##
...##### ###.#... .#####.#
....#..# ...##..# .#.###..
.####... #..#.... .#......

#..#.##. .#..###. #.##....
#.####.. #.####.# .#.###..
###.#.#. ..#.#### ##.#..##
#.####.. ..##..## ######.#
##..##.# ...#...# .#.#.#..
...#..#. .#.#.##. .###.###
.#.#.... #.##.#.. .###.##.
###.#... #..#.##. ######..

.#.#.### .##.##.# ..#.##..
.####.## #.#...## #.#..#.#
..#.#..# ..#.#.#. ####.###
#..####. ..#.#.#. ###.###.
#####..# ####...# ##....##
#.##..#. .#...#.. ####...#
.#.###.. ##..##.. ####.##.
...###.. .##...#. ..#..###
```

Remove the gaps to form the actual image:

```plain
.#.#..#.##...#.##..#####
###....#.#....#..#......
##.##.###.#.#..######...
###.#####...#.#####.#..#
##.#....#.##.####...#.##
...########.#....#####.#
....#..#...##..#.#.###..
.####...#..#.....#......
#..#.##..#..###.#.##....
#.####..#.####.#.#.###..
###.#.#...#.######.#..##
#.####....##..########.#
##..##.#...#...#.#.#.#..
...#..#..#.#.##..###.###
.#.#....#.##.#...###.##.
###.#...#..#.##.######..
.#.#.###.##.##.#..#.##..
.####.###.#...###.#..#.#
..#.#..#..#.#.#.####.###
#..####...#.#.#.###.###.
#####..#####...###....##
#.##..#..#...#..####...#
.#.###..##..##..####.##.
...###...##...#...#..###
```

Now, you're ready to search for sea monsters! Because your image is monochrome, a sea monster will look like this:

    sea_monster = """
                        #
      #    ##    ##    ###
       #  #  #  #  #  #
    """

When looking for this pattern in the image, the spaces can be anything; only the # need to match. Also, you might need to rotate or flip your image before it's oriented correctly to find sea monsters. In the above image, after flipping and rotating it to the appropriate orientation, there are two sea monsters (marked with O):

```plain
.####...#####..#...###..
#####..#..#.#.####..#.#.
.#.#...#.###...#.##.O#..
#.O.##.OO#.#.OO.##.OOO##
..#O.#O#.O##O..O.#O##.##
...#.#..##.##...#..#..##
#.##.#..#.#..#..##.#.#..
.###.##.....#...###.#...
#.####.#.#....##.#..#.#.
##...#..#....#..#...####
..#.##...###..#.#####..#
....#.##.#.#####....#...
..##.##.###.....#.##..#.
#...#...###..####....##.
.#.##...#.##.#.#.###...#
#.###.#..####...##..#...
#.###...#.##...#.##O###.
.O##.#OO.###OO##..OOO##.
..O#.O..O..O.#O##O##.###
#.#..##.########..#..##.
#.#####..#.#...##..#....
#....##..#.#########..##
#...#.....#..##...###.##
#..###....##.#...##.##.#
```

Determine how rough the waters are in the sea monsters' habitat by counting the number of # that are not part of a sea monster. In the above example, the habitat's water roughness is 273.

How many # are not part of a sea monster?

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

    createChart = (map=[])->
      new_w = map[0][0].rows.length - 2
      chart = blankMap map.length * new_w

      for maprow, cy in map
        for tile, cx in maprow
          for row, y in tile.rows
            continue if y in [0, 9]
            for cell, x in row
              continue if x in [0, 9]
              chart[cy*new_w+y-1][cx*new_w+x-1] = cell

      new Tile 'chart', chart



    parseMonster = (text='')->
      text
      .split "\n"
      .map (row)->
        row.split ''

    markSeaMonsters = (chart)->
      for perm in chart.permutations()
        if coords = findSeaMonsters perm
          for [y,x] in coords
            for smrow, smy in parseMonster sea_monster
              for smcell, smx in smrow
                continue unless smcell is '#'
                perm.rows[y+smy][x+smx] = 'O'
          return perm

    findSeaMonsters = (chart, coords=[])->
      for row, y in chart.rows
        for cell, x in row
          if isSeaMonster chart, y, x
            coords.push [y,x]
      coords.length and coords

    isSeaMonster = (chart, y=0, x=0)->
      sm = parseMonster sea_monster
      return false if y > chart.rows.length - sm.length
      return false if x > chart.rows.length - sm[1].length
      for smrow, smy in sm
        for smcell, smx in smrow
          continue unless smcell is '#'
          return false unless chart.rows[y+smy][x+smx] is '#'
      true

    turbulenceCoefficient = (chart, turb=0)->
      for row in chart.rows
        for cell in row
          turb+=1 if cell is '#'
      turb


## Tests

    { log } = console
    assert = require 'assert'

    assert 273 is turbulenceCoefficient markSeaMonsters createChart fillMap sort parseInput input


## Run

    log turbulenceCoefficient markSeaMonsters createChart fillMap sort parseInput require './input'
