# Part Two

The final step in breaking the XMAS encryption relies on the invalid number you just found: you must find a contiguous set of at least two numbers in your list which sum to the invalid number from step 1.

Again consider the above example:

    input = """
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
    """

In this list, adding up all of the numbers from 15 through 40 produces the invalid number from step 1, 127. (Of course, the contiguous set of numbers in your actual list might be much longer.)

To find the encryption weakness, add together the smallest and largest number in this contiguous range; in this example, these are 15 and 47, producing 62.

What is the encryption weakness in your XMAS-encrypted list of numbers?


## Defs

    parseInput = (text='')->
      text
      .split "\n"
      .map parseFloat

    findFirstInvalidNumber = (windowSize=5, stream=[])->
      for val, idx in stream
        continue if idx < windowSize
        return val unless !! findSumPair val, stream[idx-windowSize...idx]
      null

    findSumPair = (target, values)->
      for i in values
        for j in values when j isnt i
          return [i,j] if i + j is target
      false

    findEncryptionWeakness = (windowSize=5, stream=[])->
      target = findFirstInvalidNumber windowSize, stream
      window = findSumList target, stream
      Math.max(window...) + Math.min(window...)

    findSumList = (target, values, start=0)->
      while start < values.length
        for i in [1..(values.length-start)]
          window = values[start...(start+i)]
          total = sumArray window

          # did we find the target?
          return window if total is target

          # did we surpass the target?
          break if total > target

        # let's try the next offset
        start += 1

    sumArray = (array=[])-> array.reduce (memo=0, val)-> memo + val


## Tests

    { log } = console
    assert = require 'assert'

    assert 62 is findEncryptionWeakness 5, parseInput input

## Run

    log findEncryptionWeakness 25, parseInput require './input'
