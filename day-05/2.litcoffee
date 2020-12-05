# Part Two

Ding! The "fasten seat belt" signs have turned on. Time to find your seat.

It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.

Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.

What is the ID of your seat?

## Defs

    { log } = console

    class Seat
      constructor: (address='')->
        [ _, row, col] = address.match /^([FB]{7})([RL]{3})/

        @rowAddr  = row
        @colAddr  = col

      row: ->
        row = @rowAddr
          .replace /F/g, 0
          .replace /B/g, 1

        parseInt row, 2

      col: ->
        col = @colAddr
          .replace /L/g, 0
          .replace /R/g, 1

        parseInt col, 2

      seat: ->
        @row() * 8 + @col()


    seatNumbers = (text='')->
      text.split("\n").map (line)->
        new Seat(line).seat()

    possibleSeatNumbers = (text='')->
      occupiedSeats = seatNumbers text
      l = Math.min ...occupiedSeats
      h = Math.max ...occupiedSeats
      [l..h]

    emptySeat = (text='')->
      occupiedSeats = seatNumbers text
      for num in possibleSeatNumbers text
        return num unless num in occupiedSeats


## Run

    # [1,2,3,4,5,6,7,8]
    # [1,2,3,4,  6,7,8]
    log emptySeat require './input'
