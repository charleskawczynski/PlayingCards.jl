module PlayingCards

using Random: randperm
import Random: shuffle!

import Base

# Suits
export Club, Spade, Heart, Diamond
export ♣, ♠, ♡, ♢ # aliases

# Card, and Suit
export Card, Suit

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
    Card{S <: Suit, R <: Rank}

A playing card. Can be constructed with

`Card(suit, rank)`, or by convenience
constructors. For example:
 - `2♢` (equivalent to `Card(2, Diamond())`)
 - `A♡` (equivalent to `Card(1, Heart())`)

A `10`-`suit` can be constructed with one of two constructors:
 - `10♣` (equivalent to `Card(10, Club())`)
or
 - `T♠`  (equivalent to `Card(10, Spade())`)
"""
struct Card{S <: Suit}
    rank::UInt8
    # Support either order input:
    function Card(rank::Int, ::S) where {S<:Suit}
        @assert 1 ≤ rank ≤ 13
        new{S}(UInt8(rank))
    end
    function Card(::S, rank::Int) where {S<:Suit}
        @assert 1 ≤ rank ≤ 13
        new{S}(UInt8(rank))
    end
end

# Allow constructing cards with, e.g., `3♡`
Base.:*(r::Integer, s::Suit) = Card(s, r)

# And for face cards:
# Not to be confused with
# ♡, ♡
# ♢, ♢
for s in "♣♢♡♠", (f,typ) in zip((:J,:Q,:K,:A),(11,12,13,1))
    ss, sc = Symbol(s), Symbol("$f$s")
    @eval (export $sc; const $sc = Card($typ,$ss))
end
for s in "♣♢♡♠"
    ss, sc = Symbol(s), Symbol("T$s")
    @eval (export $sc; const $sc = Card(10,$ss))
end

#####
##### Methods
#####

Base.string(::Club) = "♣"
Base.string(::Spade) = "♠"
Base.string(::Heart) = "♡"
Base.string(::Diamond) = "♢"
Base.string(::Type{Club}) = "♣"
Base.string(::Type{Spade}) = "♠"
Base.string(::Type{Heart}) = "♡"
Base.string(::Type{Diamond}) = "♢"

function rank_string(r::UInt8)
    2 ≤ r ≤ 9 && return "$(r)"
    r == 10 && return "T"
    r == 11 && return "J"
    r == 12 && return "Q"
    r == 13 && return "K"
    r == 1 && return "A"
    error("Unrecognized rank string")
end

suit_type(card::Card{S}) where {S} = string(S)
Base.string(card::Card) = rank_string(card.rank)*string(suit_type(card))

Base.show(io::IO, card::Card) = print(io, string(card))

# TODO: define Base.isless ? Problem: high Ace vs. low Ace

"""
    high_value(::Card)
    high_value(::Rank)

The high rank value. For example:
 - `Rank(1)` -> 14 (use [`low_value`](@ref) for the low Ace value.)
 - `Rank(5)` -> 5
"""
high_value(c::Card) = c.rank == 1 ? 14 : c.rank

"""
    low_value(::Card)
    low_value(::Rank)

The low rank value. For example:
 - `Rank(1)` -> 1 (use [`high_value`](@ref) for the high Ace value.)
 - `Rank(5)` -> 5
"""
low_value(c::Card) = c.rank

"""
    rank(::Card)

The card `rank` (e.g., `Ace`, `Rank`).
"""
rank(c::Card) = c.rank

"""
    suit(::Card)

The card `suit` (e.g., `Heart`, `Club`).
"""
suit(c::Card{S}) where {S} = S()

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
color(suit::Suit) = color(typeof(suit))
color(card::Card{S}) where {S} = color(S)

#####
##### Full deck/suit/rank methods
#####

"""
    ranks

A Tuple of ranks `1:13`.
"""
ranks() = 1:13

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
    pop!(deck::Deck, card::Card)

Remove `n` cards from the `deck`.
or
Remove `card` from the `deck`.
"""
Base.pop!(deck::Deck, n::Integer = 1) = ntuple(i->pop!(deck.cards), n)
function Base.pop!(deck::Deck, card::Card)
    L0 = length(deck)
    filter!(x -> x ≠ card, deck.cards)
    L0 == length(deck)+1 || error("Could not pop $(card) from deck.")
    return card
end

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
