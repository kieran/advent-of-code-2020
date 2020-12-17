# Part Two ---
Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the remaining valid tickets to determine which field is which.

Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is consistent between all tickets: if seat is the third field, it is the third field on every ticket, including your ticket.

For example, suppose you have the following notes:

    input = """
      class: 0-1 or 4-19
      row: 0-5 or 8-19
      seat: 0-13 or 16-19

      your ticket:
      11,12,13

      nearby tickets:
      3,9,18
      15,1,5
      5,14,9
    """

Based on the nearby tickets in the above example, the first position must be row, the second position must be class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and seat is 13.

Once you work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?

## Defs

    { every, select, sortBy } = require 'underscore'


    parseInput = (text='')->

      # split into sections
      [ rules, ticket, tickets ] = \
      text
      .split "\n\n"

      # get data lines
      rules = rules.split "\n"
      [_, ticket] = ticket.split "\n"
      [_, tickets...] = tickets.split "\n"

      # coerce values
      ticket  = new Ticket ticket
      tickets = tickets.map (t)-> new Ticket t
      rules   = rules.map (def)-> new Rule def

      # return date in sections
      [rules, tickets, ticket]

    class Ticket
      constructor: (str='')->
        @values = \
          str
          .split ','
          .map parseFloat

      valid: (rules=[])->
        for num in @values
          validities = rules.map (rule)-> rule.validFor num
          return false unless true in validities
        true

    class Rule
      constructor: (str='')->
        [_, @name, r1s, r1e, r2s, r2e, ] = str.match /^([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)$/
        @ranges = [
          [parseFloat(r1s)..parseFloat(r1e)]
          [parseFloat(r2s)..parseFloat(r2e)]
        ]

      validFor: (num)=>
        return true if num in @ranges[0]
        return true if num in @ranges[1]
        false

      valid_indexes: (tickets=[])=>
        ret = []
        for _, idx in tickets[0].values
          ret.push idx if every tickets.map (t)=> @validFor t.values[idx]
        ret


    valid_tickets = (rules=[], tickets=[])->
      select tickets, (t)-> t.valid rules

    rule_map = (rules=[], tickets=[], map)->
      rules = sortedRules rules, tickets
      map ?= new Array(tickets[0].values.length)

      # return if we're done
      return map if rules.length is 0

      for entry, idx in map when not entry
        # I don't think we need to filter by valid_indexes
        # since we already sort the rules by cardinality
        for rule in rules #when idx in rule.valid_indexes tickets
          new_rules = (r for r in rules when r isnt rule)
          new_map = [map...]
          new_map[idx] = rule.name
          return res if res = rule_map new_rules, tickets, new_map

    sortedRules = (rules=[], tickets=[])->
      sortBy rules, (rule)-> rule.valid_indexes(tickets).length

    departureValues = (rules=[], tickets=[], ticket={})->
      map = rule_map rules, valid_tickets rules, tickets
      departure_indexes = (idx for entry, idx in map when /departure/.test entry)
      (ticket.values[idx] for idx in departure_indexes)

    departureProduct = (rules=[], tickets=[], ticket={})->
      multArray departureValues rules, tickets, ticket

    multArray = (array=[])-> array.reduce (memo=1, val=1)-> memo * val

## Tests

    { log } = console

    # nothing new to assert

## Run

    log departureProduct ...parseInput require './input'
