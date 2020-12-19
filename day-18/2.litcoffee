# Part Two

You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they reach the next section: advanced math.

Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with. Instead, addition is evaluated before multiplication.

For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

```plain
1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
  3   *   7   * 5 + 6
  3   *   7   *  11
     21       *  11
         231
```

Here are the other examples from above:

```plain
1 + (2 * 3) + (4 * (5 + 6)) still becomes 51.
2 * 3 + (4 * 5) becomes 46.
5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.
```

What do you get if you add up the results of evaluating the homework problems using these new rules?

## Defs

    tokenize = (str='', tree=[])->
      while [c, str] = [str[0], str[1...]]
        break unless c
        if parseFloat(c) in [0..9]
          tree.push parseFloat c
        else if c is '+' or c is '*'
          tree.push c
        else if c is '('
          subtree = tokenize str
          str = subtree.remainder
          tree.push subtree
        else if c is ')'
          tree.remainder = str
          return tree
      tree


    evaluateLine = (arr=[])->
      # evaluate parens
      for el, idx in arr when 'object' is typeof el
        arr[idx] = evaluateLine el

      # evaluate additions
      i = 0
      while i < arr.length
        [left, op, right] = arr[i..(i+2)]
        if op and right and op is '+'
          arr = [
            arr[...i]...
            left + right
            arr[(i+3)...]...
          ]
          continue
        i+=1

      # evaluate multiplications (yes it's similar)
      i = 0
      while i < arr.length
        [left, op, right] = arr[i..(i+2)]
        if op and right and op is '*'
          arr = [
            arr[...i]...
            left * right
            arr[(i+3)...]...
          ]
          continue
        i+=1

      # return the last remaining value (the answer)
      arr[0]

    evaluate = (text='')->
      text
      .split "\n"
      .map (line)->
        evaluateLine tokenize line
      .reduce (memo=0, val)-> memo + val

## Tests

    { log } = console
    assert = require 'assert'

    assert 231 is evaluate "1 + 2 * 3 + 4 * 5 + 6"
    assert 51 is evaluate "1 + (2 * 3) + (4 * (5 + 6))"
    assert 46 is evaluate "2 * 3 + (4 * 5)"
    assert 1445 is evaluate "5 + (8 * 3 + 9 + 3 * 4 * 3)"
    assert 669060 is evaluate "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
    assert 23340 is evaluate "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"


## Run

    log evaluate require './input'
