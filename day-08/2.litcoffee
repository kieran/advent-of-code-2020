# Part Two

After some careful analysis, you believe that exactly one instruction is corrupted.

Somewhere in the program, either a jmp is supposed to be a nop, or a nop is supposed to be a jmp. (No acc instructions were harmed in the corruption of this boot code.)

The program is supposed to terminate by attempting to execute an instruction immediately after the last instruction in the file. By changing exactly one jmp or nop, you can repair the boot code and make it terminate correctly.

For example, consider the same program from above:

    input = """
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
    """

If you change the first instruction from nop +0 to jmp +0, it would create a single-instruction infinite loop, never leaving that instruction. If you change almost any of the jmp instructions, the program will still eventually find another jmp instruction and loop forever.

However, if you change the second-to-last instruction (from jmp -4 to nop -4), the program terminates! The instructions are visited in this order:

```plain
nop +0  | 1
acc +1  | 2
jmp +4  | 3
acc +3  |
jmp -3  |
acc -99 |
acc +1  | 4
nop -4  | 5
acc +6  | 6
```

After the last instruction (acc +6), the program terminates by attempting to run the instruction below the last instruction in the file. With this change, after the program terminates, the accumulator contains the value 8 (acc +1, acc +1, acc +6).

Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp). What is the value of the accumulator after the program terminates?

## Defs

    permute = (steps=[])->
      steps = steps.split "\n" if typeof steps is 'string'

      for step, idx in steps

        if /jmp/.test step
          new_steps = [ steps... ]
          new_steps[idx] = step.replace 'jmp', 'nop'

        else if /nop/.test step
          new_steps = [ steps... ]
          new_steps[idx] = step.replace 'nop', 'jmp'

        return val if val = run new_steps

    run = (steps=[], acc=0, step=0, seen=[])->
      steps = steps.split "\n" if typeof steps is 'string'

      while true
        # we won!
        return acc if step is steps.length

        # we broke!
        return false if step in seen

        # record it
        seen.push step

        # parse it
        [ins, arg] = parseStep steps[step]

        # evaluate it
        switch ins
          when 'acc'
            acc = acc += arg
            step += 1
          when 'jmp'
            step += arg
          else
            step += 1

      return acc

    parseStep = (line='')->
      [_, instr, arg ] = /^(\w{3})\s([+-]\d+)$/.exec line
      [
        instr
        parseFloat arg
      ]


## Tests

    { log } = console
    assert = require 'assert'

    assert 8 is permute input

## Run

    log permute require './input'
