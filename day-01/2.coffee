{ log, assert } = console


#
# Def
#
find_factors = (values, prod)->
  for val in values
    for val2 in values when val2 isnt val
      other = prod - val - val2
      return [val, val2, other] if other in values

product = (a, b, c)-> a * b * c


#
# Test
#
input = [
  1721
  979
  366
  299
  675
  1456
]

assert 241861950 is product ...find_factors input, 2020


#
# Run
#
input = require './input'

log product ...find_factors input, 2020
