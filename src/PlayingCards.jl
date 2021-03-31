module PlayingCards

using Random: randperm
import Random: shuffle!

import Base

# Ranks
export NumberCard, Jack, Queen, King, Ace

# Suits
export Club, Spade, Heart, Diamond
export ♣, ♠, ♡, ♢ # aliases

# Card, and Suit / Rank
export Card, Suit, Rank

# Card properties
export suit, rank, rank_type, high_value, low_value, color

# Lists of all ranks / suits
export ranks, suits

# Deck & deck-related methods
export Deck, shuffle!, full_deck, ordered_deck

#####
##### Types
#####

"""
    Suit

Subtypes are used for each
card suit (all of which have aliases):
 - `Club`    (alias `♣`)
 - `Spade`   (alias `♠`)
 - `Heart`   (alias `♡`)
 - `Diamond` (alias `♢`)
"""
abstract type Suit end

struct Club <: Suit end
struct Spade <: Suit end
struct Heart <: Suit end
struct Diamond <: Suit end

const ♣ = Club()
const ♠ = Spade()
const ♡ = Heart()
const ♢ = Diamond()

"""
    Rank

The card rank, subtypes are used
for each card rank including
 - `Ace`
 - `King`
 - `Queen`
 - `Jack`
 - `NumberCard{N}` where `2 ≤ N ≤ 10`
"""
abstract type Rank end

struct NumberCard{N} <: Rank end
function NumberCard(N::Int)
    @assert 2 ≤ N ≤ 10
    return NumberCard{N}()
end

struct Jack <: Rank end
struct Queen <: Rank end
struct King <: Rank end
struct Ace <: Rank end

"""
    Card{R <: Rank, S <: Suit}

A playing card. Can be constructed with

`Card(rank, suit)`, or by convenience
constructors. For example:
 - `2♢` (equivalent to `Card(NumberCard(2), Diamond())`)
 - `A♡` (equivalent to `Card(Ace, Heart())`)

A `10`-`suit` can be constructed with one of two constructors:
 - `10♣` (equivalent to `Card(NumberCard(10), Club())`)
or
 - `T♠`  (equivalent to `Card(NumberCard(10), Spade())`)
"""
struct Card{R <: Rank, S <: Suit}
    rank::R
    suit::S
end

# Allow constructing cards with, e.g., `3♡`
Base.:*(r::Integer, s::Suit) = Card(NumberCard{r}(), s)

# And for face cards:
# Not to be confused with
# ♡, ♡
# ♢, ♢
for s in "♣♢♡♠", (f,typ) in zip((:J,:Q,:K,:A),(Jack(),Queen(),King(),Ace()))
    ss, sc = Symbol(s), Symbol("$f$s")
    @eval (export $sc; const $sc = Card($typ,$ss))
end
for s in "♣♢♡♠"
    ss, sc = Symbol(s), Symbol("T$s")
    @eval (export $sc; const $sc = Card(NumberCard{10}(),$ss))
end

#####
##### Methods
#####

Base.string(::Club) = "♣"
Base.string(::Spade) = "♠"
Base.string(::Heart) = "♡"
Base.string(::Diamond) = "♢"

Base.string(card::Card) = string(card.rank)*string(card.suit)
Base.string(r::NumberCard{N}) where {N}  = "$N"
Base.string(r::NumberCard{10}) = "T"
Base.string(r::Jack)  = "J"
Base.string(r::Queen) = "Q"
Base.string(r::King)  = "K"
Base.string(r::Ace)   = "A"
Base.string(card::Card{Jack})  = string(card.rank)*string(card.suit)
Base.string(card::Card{Queen}) = string(card.rank)*string(card.suit)
Base.string(card::Card{King})  = string(card.rank)*string(card.suit)
Base.string(card::Card{Ace})   = string(card.rank)*string(card.suit)

Base.show(io::IO, card::Card) = print(io, string(card))

# TODO: define Base.isless ? Problem: high Ace vs. low Ace

"""
    high_value(::Card)
    high_value(::Rank)

The high rank value. For example:
 - `Ace` -> 14 (use [`low_value`](@ref) for the low value.)
 - `Jack` -> 11
 - `NumberCard{N}` -> N
"""
high_value(r::Rank) = high_value(typeof(r))
high_value(::NumberCard{V}) where {V} = V
high_value(::Type{NumberCard{N}}) where {N} = N
high_value(::Type{Jack}) = 11
high_value(::Type{Queen}) = 12
high_value(::Type{King}) = 13
high_value(::Type{Ace}) = 14

"""
    low_value(::Card)
    low_value(::Rank)

The low rank value. For example:
 - `Ace` -> 1 (use [`high_value`](@ref) for the high value.)
 - `Jack` -> 11
 - `NumberCard{N}` -> N
"""
low_value(::Type{T}) where {T} = high_value(T)
low_value(::Type{Ace}) = 1
low_value(r::Rank) = low_value(typeof(r))
low_value(card::Card) = low_value(rank(card))

"""
    rank_type(::Card)

The type of the `rank`.
"""
rank_type(::Card{R,S}) where {R,S} = R
rank_type(::Type{Card{R,S}}) where {R,S} = R

high_value(c::Card) = high_value(c.rank)

"""
    rank(::Card)

The card `rank` (e.g., `Ace`, `Jack`, `NumberCard{N}`).
"""
rank(c::Card) = c.rank

"""
    suit(::Card)

The card `suit` (e.g., `Heart`, `Club`).
"""
suit(c::Card) = c.suit

"""
    color(::Card)
    color(::Suit)

A `Symbol` (`:red`, or `:black`) indicating
the color of the suit or card.
"""
color(::Type{Club}) = :black
color(::Type{Spade}) = :black
color(::Type{Heart}) = :red
color(::Type{Diamond}) = :red
color(s::Suit) = color(typeof(s))
color(card::Card) = color(suit(card))

#####
##### Full deck/suit/rank methods
#####

"""
    ranks

A Tuple of all ranks.
"""
ranks() = (map(i->NumberCard{i}(), 2:10)..., Jack(), Queen(), King(), Ace())

"""
    suits

A Tuple of all suits
"""
suits() = (♣, ♠, ♡, ♢)

"""
    full_deck

A vector of a cards
containing a full deck
"""
full_deck() = Card[Card(r,s) for s in suits() for r in ranks()]


#### Deck

"""
    Deck

Deck of cards (backed by a `Vector{Card}`)
"""
struct Deck{C <: Vector}
    cards::C
end

Base.length(deck::Deck) = length(deck.cards)

Base.iterate(deck::Deck, state=1) = Base.iterate(deck.cards, state)

function Base.show(io::IO, deck::Deck)
    for (i, card) in enumerate(deck)
        Base.show(io, card)
        if mod(i, 13) == 0
            println(io)
        else
            print(io, " ")
        end
    end
end

"""
    pop!(deck::Deck, n::Int = 1)

Remove `n` cards from the `deck`.
"""
Base.pop!(deck::Deck, n::Integer = 1) = ntuple(i->pop!(deck.cards), n)

"""
    ordered_deck

An ordered `Deck` of cards.
"""
ordered_deck() = Deck(full_deck())

"""
    shuffle!

Shuffle the deck! `shuffle!` uses
`Random.randperm` to shuffle the deck.
"""
function shuffle!(deck::Deck)
    deck.cards .= deck.cards[randperm(length(deck.cards))]
    nothing
end

end # module
