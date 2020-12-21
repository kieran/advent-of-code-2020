# Part Two

Impressed, the Elves issue you a challenge: determine the 30000000th number spoken. For example, given the same starting numbers as above:

```plain
Given 0,3,6, the 30000000th number spoken is 175594.
Given 1,3,2, the 30000000th number spoken is 2578.
Given 2,1,3, the 30000000th number spoken is 3544142.
Given 1,2,3, the 30000000th number spoken is 261214.
Given 2,3,1, the 30000000th number spoken is 6895259.
Given 3,2,1, the 30000000th number spoken is 18.
Given 3,1,2, the 30000000th number spoken is 362.
```
Given your starting numbers, what will be the 30000000th number spoken?


## Defs

    parseInput = (text='')->
      text
      .split ','
      .map parseFloat

    prop = (target=2020, arr=[], map=[], iter=0)->
      [ arr..., next ] = arr unless next

      for n, idx in arr
        map[n] = idx
        iter += 1

      until iter >= target
        # log iter unless iter % 100000
        li = map[next]
        if li >= 0
          newNext = iter - li
        else
          newNext = 0

        map[next] = iter

        iter += 1
        return next if iter is target
        next = newNext


## Tests

    { log, time, timeEnd } = console
    assert = require 'assert'

    # assert 175594   is prop 30000000, parseInput "0,3,6"
    # assert 2578     is prop 30000000, parseInput "1,3,2"
    # assert 3544142  is prop 30000000, parseInput "2,1,3"
    # assert 261214   is prop 30000000, parseInput "1,2,3"
    # assert 6895259  is prop 30000000, parseInput "2,3,1"
    # assert 18       is prop 30000000, parseInput "3,2,1"
    # assert 362      is prop 30000000, parseInput "3,1,2"

## Run

Your puzzle input is

    input = "13,16,0,12,15,1"

    log prop 30000000, parseInput input
