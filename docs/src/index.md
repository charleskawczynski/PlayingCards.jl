# PlayingCards.jl

A package for representing playing cards for card games (for a standard deck of fifty two).

## Cards

A playing `Card` is consists of a rank:

 - `Rank(N::Int)` where `1 ≤ N ≤ 13` where
 - `N = 1` represents an Ace (which can have high or low values via `high_value` and `low_value`)
 - `N = 11` represents a Jack
 - `N = 12` represents a Queen
 - `N = 13` represents a King

and a suit:
 - `♣` (`Club`)
 - `♠` (`Spade`)
 - `♡` (`Heart`)
 - `♢` (`Diamond`)

The value of the rank can be retrieved from `high_value` and `low_value`:

 - `high_value(c::Card) == low_value(c::Card) == c.rank`
 - `high_value(::Card) = 14` for Ace
 - `low_value(::Card) = 1` for Ace

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
