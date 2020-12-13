# Part Two

The shuttle company is running a contest: one gold coin for anyone that can find the earliest timestamp such that the first bus ID departs at that time and each subsequent listed bus ID departs at that subsequent minute. (The first line in your input is no longer relevant.)

For example, suppose you have the same list of bus IDs as above:

    input = """
      939
      7,13,x,x,59,x,31,19
    """

An x in the schedule means there are no constraints on what bus IDs must depart at that time.

This means you are looking for the earliest timestamp (called t) such that:

```plain
Bus ID 7 departs at timestamp t.
Bus ID 13 departs one minute after timestamp t.
There are no requirements or restrictions on departures at two or three minutes after timestamp t.
Bus ID 59 departs four minutes after timestamp t.
There are no requirements or restrictions on departures at five minutes after timestamp t.
Bus ID 31 departs six minutes after timestamp t.
Bus ID 19 departs seven minutes after timestamp t.
```

The only bus departures that matter are the listed bus IDs at their specific offsets from t. Those bus IDs can depart at other times, and other bus IDs can depart at those times. For example, in the list above, because bus ID 19 must depart seven minutes after the timestamp at which bus ID 7 departs, bus ID 7 will always also be departing with bus ID 19 at seven minutes after timestamp t.

In this example, the earliest timestamp at which this occurs is 1068781:

```plain
time   bus 7   bus 13  bus 59  bus 31  bus 19
929      .       .       .       .       .
930      .       .       .       D       .
931      D       .       .       .       D
932      .       .       .       .       .
933      .       .       .       .       .
934      .       .       .       .       .
935      .       .       .       .       .
936      .       D       .       .       .
937      .       .       .       .       .
938      D       .       .       .       .
939      .       .       .       .       .
940      .       .       .       .       .
941      .       .       .       .       .
942      .       .       .       .       .
943      .       .       .       .       .
944      .       .       D       .       .
945      D       .       .       .       .
946      .       .       .       .       .
947      .       .       .       .       .
948      .       .       .       .       .
949      .       D       .       .       .
```

In the above example, bus ID 7 departs at timestamp 1068788 (seven minutes after t). This is fine; the only requirement on that minute is that bus ID 19 departs then, and it does.

Here are some other examples:

```plain
The earliest timestamp that matches the list 17,x,13,19 is 3417.
67,7,59,61 first occurs at timestamp 754018.
67,x,7,59,61 first occurs at timestamp 779210.
67,7,x,59,61 first occurs at timestamp 1261476.
1789,37,47,1889 first occurs at timestamp 1202161486.
```

However, with so many bus IDs in your list, surely the actual earliest timestamp will be larger than 100000000000000!

What is the earliest timestamp such that all of the listed bus IDs depart at offsets matching their positions in the list?

## Defs

    { sortBy } = require 'underscore'

    parseInput = (text='')->
      [ now, schedule ] = text.split "\n"

      now = parseFloat now
      ids = schedule
        .split ','
        .map parseFloat

      ([id, idx] for id, idx in ids when id)

    # check every multiple of the first departure time
    # and see if it lines up with a second departure time
    # and if so, return the new combined window size and departure time
    firstCommonDeparture = ([window_size_1, offset_1], [window_size_2, offset_2], step=1)->
      step += 1 while (n = offset_1 + window_size_1 * step) % window_size_2 isnt (offset_2 + window_size_2) % window_size_2
      [window_size_1*window_size_2, n]


    # given a list of departure times and window size,
    # iteratively find the common ones
    findCommonDeparture = (departures=[])->
      # sort departures by largest window for efficiency
      departures = sortBy departures, ([id, _])-> -id

      for [time, offset], idx in departures
        # skip the first one since we don't have anything to pair it with yet
        unless idx
          [ prev_time, prev_offset ] = [time, offset]
          continue
        # calculate the next common departure for this pair of times
        [ prev_time, prev_offset ] = firstCommonDeparture [prev_time, prev_offset], [time, offset]
      # the departure time is the common time *minus* the window size
      prev_time - prev_offset


## Tests

    { log } = console
    assert = require 'assert'

    assert 1068781 is findCommonDeparture parseInput input

## Run

    log findCommonDeparture parseInput require './input'
