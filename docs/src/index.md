# PlayingCards.jl

A package for representing playing cards for card games (for a standard deck of fifty two).

## Cards

A playing `Card` is consists of a rank:

 - `NumberCard(N::Int)` where `2 ≤ N ≤ 10`
 - `Jack`
 - `Queen`
 - `King`
 - `Ace`

and a suit:
 - `♣` (`Club`)
 - `♠` (`Spade`)
 - `♡` (`Heart`)
 - `♢` (`Diamond`)

The high_value of the rank can be retrieved from `high_value` and `low_value`:

 - `high_value(::Card{NumberCard{N}}) where {N} = N`
 - `high_value(::Card{Jack}) = 11`
 - `high_value(::Card{Queen}) = 12`
 - `high_value(::Card{King}) = 13`
 - `high_value(::Card{Ace}) = 14`, `low_value(::Card{Ace}) = 1`
 - `high_value(card::Card) = low_value(card)`

`Card`s have convenience constructors and methods for extracting information about them:

```@example
using PlayingCards
@show card = A♡
@show string(card)
@show suit(A♡)
@show rank(A♠)
@show high_value(A♢)
@show high_value(J♣)
@show low_value(A♡)
nothing
```

## Decks

A `Deck` is a struct with a `Vector` of `Card`s, which has a few convenience methods:

```@example
using PlayingCards
@show deck = ordered_deck()

shuffle!(deck)

@show hand = pop!(deck, 2)

@show deck
nothing
```
