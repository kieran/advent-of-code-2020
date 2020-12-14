# Part Two

For some reason, the sea port's computer system still can't communicate with your ferry's docking program. It must be using version 2 of the decoder chip!

A version 2 decoder chip doesn't modify the values being written at all. Instead, it acts as a memory address decoder. Immediately before a value is written to memory, each bit in the bitmask modifies the corresponding bit of the destination memory address in the following way:

```plain
If the bitmask bit is 0, the corresponding memory address bit is unchanged.
If the bitmask bit is 1, the corresponding memory address bit is overwritten with 1.
If the bitmask bit is X, the corresponding memory address bit is floating.
```

A floating bit is not connected to anything and instead fluctuates unpredictably. In practice, this means the floating bits will take on all possible values, potentially causing many memory addresses to be written all at once!

For example, consider the following program:

    input = """
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
    """

When this program goes to write to memory address 42, it first applies the bitmask:

```plain
address: 000000000000000000000000000000101010  (decimal 42)
mask:    000000000000000000000000000000X1001X
result:  000000000000000000000000000000X1101X
```

After applying the mask, four bits are overwritten, three of which are different, and two of which are floating. Floating bits take on every possible combination of values; with two floating bits, four actual memory addresses are written:

```plain
000000000000000000000000000000011010  (decimal 26)
000000000000000000000000000000011011  (decimal 27)
000000000000000000000000000000111010  (decimal 58)
000000000000000000000000000000111011  (decimal 59)
```

Next, the program is about to write to memory address 26 with a different bitmask:

```plain
address: 000000000000000000000000000000011010  (decimal 26)
mask:    00000000000000000000000000000000X0XX
result:  00000000000000000000000000000001X0XX
```

This results in an address with three floating bits, causing writes to eight memory addresses:

```plain
000000000000000000000000000000010000  (decimal 16)
000000000000000000000000000000010001  (decimal 17)
000000000000000000000000000000010010  (decimal 18)
000000000000000000000000000000010011  (decimal 19)
000000000000000000000000000000011000  (decimal 24)
000000000000000000000000000000011001  (decimal 25)
000000000000000000000000000000011010  (decimal 26)
000000000000000000000000000000011011  (decimal 27)
```

The entire 36-bit address space still begins initialized to the value 0 at every address, and you still need the sum of all values left in memory at the end of the program. In this example, the sum is 208.

Execute the initialization program using an emulator for a version 2 decoder chip. What is the sum of all values left in memory after it completes?


## Defs

    processInput = (text='', mask='', mem={})->
      for line, idx in text.split "\n"
        [mask, mem] = processLine mask, mem, line
      sumArray Object.values mem

    MASK_PATTERN = /mask\ =\ ([X01]{36})/
    MEM_PATTERN = /mem\[(\d+)\] =\ (\d+)/

    processLine = (mask='', mem={}, line='')->
      if MASK_PATTERN.test line
        [_, mask] = line.match MASK_PATTERN

      else if MEM_PATTERN.test line
        [_, add, val] = line.match MEM_PATTERN
        applyMask mem, add, mask, parseFloat val

      [mask, mem]

    # *will update* mem with val for every addr permutation
    applyMask = (mem={}, addr=0, mask='', val=0)->
      bits = parseFloat addr
        .toString 2
        .padStart 36, '0'
        .split ''

      # apply the mask to the addr, preserving the X chars
      bits[idx] = char for char, idx in mask when char isnt '0'

      # write every possible addr permutation
      mem[ad] = val for ad in permute bits.join ''

    permute = (mask='')->
      return [mask] unless /X/.test mask
      ret = []
      ret = ret.concat permute mask.replace 'X', '0'
      ret = ret.concat permute mask.replace 'X', '1'
      ret

    sumArray = (ar=[])->
      ar.reduce (memo=0, val=0)-> memo + val


## Tests

    { log } = console
    assert = require 'assert'

    assert 208 is processInput input

## Run

    log processInput require './input'
