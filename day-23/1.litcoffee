# Day 23: Crab Cups

The small crab challenges you to a game! The crab is going to mix up some cups, and you have to predict where they'll end up.

The cups will be arranged in a circle and labeled clockwise (your puzzle input). For example, if your labeling were 32415, there would be five cups in the circle; going clockwise around the circle from the first cup, the cups would be labeled 3, 2, 4, 1, 5, and then back to 3 again.

Before the crab starts, it will designate the first cup in your list as the current cup. The crab is then going to do 100 moves.

Each move, the crab does the following actions:

1. The crab picks up the three cups that are immediately clockwise of the current cup. They are removed from the circle; cup spacing is adjusted as necessary to maintain the circle.
2. The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
3. The crab places the cups it just picked up so that they are immediately clockwise of the destination cup. They keep the same order as when they were picked up.
4. The crab selects a new current cup: the cup which is immediately clockwise of the current cup.

For example, suppose your cup labeling were 389125467. If the crab were to do merely 10 moves, the following changes would occur:

```plain
-- move 1 --
cups: (3) 8  9  1  2  5  4  6  7
pick up: 8, 9, 1
destination: 2

-- move 2 --
cups:  3 (2) 8  9  1  5  4  6  7
pick up: 8, 9, 1
destination: 7

-- move 3 --
cups:  3  2 (5) 4  6  7  8  9  1
pick up: 4, 6, 7
destination: 3

-- move 4 --
cups:  7  2  5 (8) 9  1  3  4  6
pick up: 9, 1, 3
destination: 7

-- move 5 --
cups:  3  2  5  8 (4) 6  7  9  1
pick up: 6, 7, 9
destination: 3

-- move 6 --
cups:  9  2  5  8  4 (1) 3  6  7
pick up: 3, 6, 7
destination: 9

-- move 7 --
cups:  7  2  5  8  4  1 (9) 3  6
pick up: 3, 6, 7
destination: 8

-- move 8 --
cups:  8  3  6  7  4  1  9 (2) 5
pick up: 5, 8, 3
destination: 1

-- move 9 --
cups:  7  4  1  5  8  3  9  2 (6)
pick up: 7, 4, 1
destination: 5

-- move 10 --
cups: (5) 7  4  1  8  3  9  2  6
pick up: 7, 4, 1
destination: 3

-- final --
cups:  5 (8) 3  7  4  1  9  2  6
```

In the above example, the cups' values are the labels as they appear moving clockwise around the circle; the current cup is marked with ( ).

After the crab is done, what order will the cups be in? Starting after the cup labeled 1, collect the other cups' labels clockwise into a single string with no extra characters; each number except 1 should appear exactly once. In the above example, after 10 moves, the cups clockwise from 1 are labeled 9, 2, 6, 5, and so on, producing 92658374. If the crab were to complete all 100 moves, the order after cup 1 would be 67384529.

Using your labeling, simulate 100 moves. What are the labels on the cups after cup 1?

Your puzzle input is `469217538`.


## Defs

    parseInput = (str='')->
      new List str

    class List
      constructor: (str='', @head)->
        @values = str
          .split ''
          .map parseFloat

        prev = null
        for v, idx in @values
          item = new Item v
          prev?.next = item
          prev = item
          @head ?= item
          if idx is @values.length - 1
            item.next = @head

      toString: (ret=[])->
        item = h = @head
        ret.push item.val
        item = item.next
        until item is h
          ret.push item.val
          item = item.next
        ret.join ' '

      labelsAfter1: (ret=[])->
        item = h = @find 1
        item = item.next
        until item is h
          ret.push item.val
          item = item.next
        ret.join ''

      maxVal: ->
        Math.max @values...

      minVal: ->
        Math.min @values...

      find: (val=0)->
        item = @head
        until item.val is val
          item = item.next
          return null if item is @head
        item

      right: (num=0)->
        target = @head
        target = target.next for i in [0...num]
        target

      shuffle: (times=1, cups=3)->
        for i in [0...times]
          # move the cups
          @move cups
          # advance the head
          @head = @head.next
        @

      move: (cups=3)->
        # slice cups out
        # repair the list
        s = @right 1
        e = @right cups
        @head.next = @right cups+1
        e.next = null

        # find the dest
        destVal = @head.val - 1
        until dest = @find destVal
          destVal -= 1
          destVal = @maxVal() if destVal < @minVal()

        # insert the slice
        ne = dest.next
        dest.next = s
        e.next = ne

    class Item
      constructor: (@val, @next)->
        @val = parseFloat @val


## Tests

    { log } = console
    assert = require 'assert'

    list = parseInput "389125467"
    list.shuffle 100
    assert "67384529" is list.labelsAfter1()

## Run

    list = parseInput "469217538"
    list.shuffle 100
    log list.labelsAfter1()
