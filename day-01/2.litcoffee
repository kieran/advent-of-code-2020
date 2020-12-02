# Part Two

The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?

## Defs

    { log } = console
    assert  = require 'assert'

    find_entries = (values=[], target)->
      for left in values
        for middle in values when middle isnt left
          for right in values when right not in [left, middle]
            return [left, middle, right] if left + middle + right is target

      throw "no three entries sum to #{target}"

    product = ->
      Array(arguments...).reduce (val, memo=1)-> val * memo

## Tests

    input = [
      1721
      979
      366
      299
      675
      1456
    ]

    assert.deepEqual [ 979, 366, 675 ], find_entries input, 2020

    assert.equal 241861950, product ...find_entries input, 2020

## Run

    input = require './input'

    log product ...find_entries input, 2020
