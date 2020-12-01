{ log, assert } = console


#
# Def
#
find_factors = (values, prod)->
  for val in values
    other = prod - val
    return [val, other] if other in values

product = (a, b)-> a * b


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

assert 514579 is product ...find_factors input, 2020


#
# Run
#
input = require './input'

log product ...find_factors input, 2020
