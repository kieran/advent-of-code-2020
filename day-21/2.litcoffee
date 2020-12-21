# Part Two

Now that you've isolated the inert ingredients, you should have enough information to figure out which ingredient contains which allergen.

In the above example:

    input = """
      mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      trh fvjkl sbzzf mxmxvkd (contains dairy)
      sqjhc fvjkl (contains soy)
      sqjhc mxmxvkd sbzzf (contains fish)
    """

```plain
mxmxvkd contains dairy.
sqjhc contains fish.
fvjkl contains soy.
```

Arrange the ingredients alphabetically by their allergen and separate them by commas to produce your canonical dangerous ingredient list. (There should not be any spaces in your canonical dangerous ingredient list.) In the above example, this would be mxmxvkd,sqjhc,fvjkl.

Time to stock your raft with supplies. What is your canonical dangerous ingredient list?

## Defs

    {
      uniq
      flatten
      pluck
      intersection
      without
    } = require 'underscore'

    parseInput = (text='')->
      text
      .split "\n"
      .map (line)->
        [_, ing, all] = line.match /^(.*) \(contains (.*)\)$/
        ing = ing.split ' '
        all = all.split ', '
        prod = {ing, all}

    allergens = (prods=[])->
      uniq flatten pluck prods, 'all'

    ingredients = (prods=[])->
      uniq flatten pluck prods, 'ing'

    ingredientsForAllergen = (prods=[], all, ing)->
      for prod in prods when all in prod.all
        ing ?= prod.ing
        ing = intersection ing, prod.ing
      ing

    mapAllergens = (prods=[], dict={})->
      alls = allergens prods
      while alls.length > Object.keys(dict).length
        for all in alls
          ing = ingredientsForAllergen prods, all
          ing = without ing, ...Object.keys dict
          dict[ing] = all if ing.length is 1
      dict

    safeIngredients = (prods=[])->
      ings = ingredients prods
      without ings, ...Object.keys mapAllergens prods

    numSafeIngredients = (prods=[],num=0)->
      safe = safeIngredients prods
      for prod in prods
        prodsafe = intersection prod.ing, safe
        num += prodsafe.length
      num

    dangerousList = (prods=[], list=[])->
      list.push [all, ing] for ing, all of mapAllergens prods

      # natural sorts by arr as a string, which concats the entries
      list.sort()

      list
      .map (p)-> p[1]
      .join ','

## Tests

    { log } = console
    assert = require 'assert'

    assert 5 is numSafeIngredients parseInput input
    assert 'mxmxvkd,sqjhc,fvjkl' is dangerousList parseInput input

## Run

    log dangerousList parseInput require './input'
