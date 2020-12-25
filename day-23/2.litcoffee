# Part Two

Due to what you can only assume is a mistranslation (you're not exactly fluent in Crab), you are quite surprised when the crab starts arranging many cups in a circle on your raft - one million (1000000) in total.

Your labeling is still correct for the first few cups; after that, the remaining cups are just numbered in an increasing fashion starting from the number after the highest number in your list and proceeding one by one until one million is reached. (For example, if your labeling were 54321, the cups would be numbered 5, 4, 3, 2, 1, and then start counting up from 6 until one million is reached.) In this way, every number from one through one million is used exactly once.

After discovering where you made the mistake in translating Crab Numbers, you realize the small crab isn't going to do merely 100 moves; the crab is going to do ten million (10000000) moves!

The crab is going to hide your stars - one each - under the two cups that will end up immediately clockwise of cup 1. You can have them if you predict what the labels on those cups will be when the crab is finished.

In the above example (389125467), this would be 934001 and then 159792; multiplying these together produces 149245887792.

Determine which two cups will end up immediately clockwise of cup 1. What do you get if you multiply their labels together?


## Defs

    parseInput = (str='')->
      new List str

    class Item
      constructor: (@val, @next)->

    class List
      constructor: (str='', @head, @map={})->
        @values = str
          .split ''
          .map parseFloat

        @max = Math.max @values...
        @min = Math.min @values...

        prev = null
        for v in @values
          @map[v] = item = new Item v
          prev?.next = item
          prev = item

        for v in [(@max+1)..1000000]
          @max = v
          @map[v] = item = new Item v
          prev?.next = item
          prev = item

        item.next = @head = @map[@values[0]]

      shuffle: (times=1)->
        for i in [0...times]
          # move the cups
          @move()
          # advance the head
          @head = @head.next
        @

      move: ->
        # dfind the dest item
        dest = @dest()

        # reassign the nexts
        [
          @head.next.next.next.next
          @head.next
          dest.next
        ] = [
          dest.next
          @head.next.next.next.next
          @head.next
        ]

      slice: ->
        [
          @head.next
          @head.next.next
          @head.next.next.next
        ]

      sliceVals: ->
        @slice().map (i)-> i.val

      dest: ->
        destVal = @head.val - 1
        destVal = @max if destVal < @min

        while destVal in @sliceVals()
          destVal -= 1
          destVal = @max if destVal < @min

        @map[destVal]

      productAfter1: ->
        @map[1].next.val * @map[1].next.next.val


## Tests

    { log } = console
    assert = require 'assert'

    list = parseInput "389125467"
    list.shuffle 10000000
    assert 149245887792 is list.productAfter1()


## Run

    list = parseInput "469217538"
    list.shuffle 10000000
    log list.productAfter1()
