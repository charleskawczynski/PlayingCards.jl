module PlayingCards

using Random: randperm, AbstractRNG, default_rng
import Random
import Random: shuffle!

import Base

# Suits
export ♣, ♠, ♡, ♢ # aliases

# Card, and Suit
export Card, Suit

# Card properties
export suit, rank, high_value, low_value, color

# Lists of all ranks / suits
export ranks, suits

# Deck & deck-related methods
export Deck, shuffle, shuffle!, full_deck, ordered_deck

#####
##### Types
#####

"""
    Suit

Encode a suit as a 2-bit value (low bits of a `UInt8`):
- 0 = ♣ (clubs)
- 1 = ♢ (diamonds)
- 2 = ♡ (hearts)
- 3 = ♠ (spades)

Suits have global constant bindings: `♣`, `♢`, `♡`, `♠`.
"""
struct Suit
    i::UInt8
    Suit(s::Integer) = 0 ≤ s ≤ 3 ? new(s) :
        throw(ArgumentError("invalid suit number: $s"))
end

#=
```
    char(::Suit)

julia> Char.(0x2663 .- UInt8.(0:3))
4-element Array{Char,1}:
 '♣': Unicode U+2663 (category So: Symbol, other)
 '♢': Unicode U+2662 (category So: Symbol, other)
 '♡': Unicode U+2661 (category So: Symbol, other)
 '♠': Unicode U+2660 (category So: Symbol, other)
```
=#

"""
    char

Return the unicode characters:
"""
char(s::Suit) = Char(0x2663-s.i)
Base.string(s::Suit) = string(char(s))
Base.show(io::IO, s::Suit) = print(io, char(s))

"""
    Card

Encode a playing card as a 6-bit integer (low bits of a `UInt8`):
- low bits represent rank from 0 to 15
- high bits represent suit (♣, ♢, ♡ or ♠)

Ranks are assigned as follows:
- numbered cards (2 to 10) have rank equal to their number
- jacks, queens and kings have ranks 11, 12 and 13
- there are low and high aces with ranks 1 and 14, 0 is for Joker
- there are low and high jokers with ranks 0 and 15

This allows any of the standard orderings of cards ranks to be
achieved simply by choosing which aces to use.

There are a total of 64 possible card values with this scheme,
represented by `UInt8` values `0x00` through `0x3f`.
"""
struct Card
    value::UInt8
    function Card(r::Integer, s::Integer)
        0 ≤ r ≤ 13 || throw(ArgumentError("invalid card rank: $r"))
        left_bits = UInt8(s << 4)
        right_bits = UInt8(r)
        or_bits = left_bits | right_bits
        return new(or_bits)
    end
end

Card(r::Integer, s::Suit) = Card(r, s.i)

#=
```julia
value(r, s) = UInt8(s << 4) | UInt8(r)
suit(r, s) = (0x30 & value(r, s)) >>> 4
julia> suit(1, 0)+0 # 0
julia> suit(1, 1)+0 # 1
julia> suit(1, 2)+0 # 2
julia> suit(1, 3)+0 # 3
```
=#

"""
    suit(::Card)

The suit of a card
"""
suit(c::Card) = Suit((0x30 & c.value) >>> 4)

#=
```julia
value(r, s) = UInt8(s << 4) | UInt8(r)
rank(r, s) = Int8((0x0f & value(r, s)))
julia> rank(1, 0)+0 # 1
julia> rank(1, 3)+0 # 1
julia> rank(9, 3)+0 # 9
```
=#

"""
    rank(::Card)

The rank of a card
"""
rank(c::Card) = Int8((c.value & 0x0f))

const ♣ = Suit(0)
const ♢ = Suit(1)
const ♡ = Suit(2)
const ♠ = Suit(3)

# Allow constructing cards with, e.g., `3♡`
Base.:*(r::Integer, s::Suit) = Card(r, s)

function Base.show(io::IO, c::Card)
    r = rank(c)
    @assert 0 ≤ r ≤ 14
    if r == 1
        print(io, 'A')
        print(io, suit(c))
    elseif r == 0
        print(io, '🃏')
        print(io, suit(c))
    else
        print(io, "123456789TJQK"[r])
        print(io, suit(c))
    end
end

# And for face cards:
# Not to be confused with other unicode characters:
# ♡, ♡
# ♢, ♢
for s in "♣♢♡♠", (f,typ) in zip((:T,:J,:Q,:K,:A),(10,11,12,13,1))
    ss, sc = Symbol(s), Symbol("$f$s")
    @eval (export $sc; const $sc = Card($typ,$ss))
end
# 🃏 &#x1F0CF;
const 🃏♣ = Card(0, ♣); export 🃏♣
const 🃏♢ = Card(0, ♢); export 🃏♢
const 🃏♡ = Card(0, ♡); export 🃏♡
const 🃏♠ = Card(0, ♠); export 🃏♠

#####
##### Methods
#####

function rank_string(r::Int8)
    @assert 0 ≤ r ≤ 13
    if r ≤ 9
        2 ≤ r && return "$(r)"
        r == 0 && return "🃏"
        return "A"
    else
        if r < 12
            r == 11 && return "J"
            return "T"
        else
            r == 12 && return "Q"
            return "K"
        end
    end
end

Base.string(card::Card) = rank_string(rank(card))*string(suit(card))

"""
    high_value(::Card)
    high_value(::Rank)

The high rank value. For example:
 - `Rank(1)` -> 14 (use [`low_value`](@ref) for the low Ace value.)
 - `Rank(5)` -> 5
"""
high_value(c::Card) = rank(c) == 1 ? 14 : rank(c)

"""
    low_value(::Card)
    low_value(::Rank)

The low rank value. For example:
 - `Rank(1)` -> 1 (use [`high_value`](@ref) for the high Ace value.)
 - `Rank(5)` -> 5
"""
low_value(c::Card) = rank(c)

"""
    color(::Card)

A `Symbol` (`:red`, or `:black`) indicating
the color of the suit or card.
"""
function color(s::Suit)
    if s == ♣ || s == ♠
        return :black
    else
        return :red
    end
end
color(card::Card) = color(suit(card))

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

abstract type AbstractDeck end

Base.length(deck::AbstractDeck) = length(deck.cards)

Base.iterate(deck::AbstractDeck, state=1) = Base.iterate(deck.cards, state)

function Base.show(io::IO, deck::AbstractDeck)
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
    Deck

Deck of cards (backed by a `Vector{Card}`)
"""
struct Deck{C <: AbstractVector{<:Card}} <: AbstractDeck
    cards::C
end

"""
    pop!(deck::Deck, n::Int = 1)
    pop!(deck::Deck, card::Card)

Remove `n` cards from the `deck`.
or
Remove `card` from the `deck`.
"""
Base.pop!(deck::Deck, n::Integer = 1) = ntuple(i->Base.pop!(deck.cards), n)

# TODO: `pop!` should not return a tuple
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
    shuffled_deck

A randomly shuffled `Deck` of 52 cards
"""
shuffled_deck(rng::AbstractRNG = default_rng()) = shuffle!(ordered_deck())

"""
    shuffle!

Shuffle the deck! Optionally accepts an `AbstractRNG` to seed the shuffle.
"""
shuffle!(deck::Deck) = shuffle!(default_rng(), deck)

function shuffle!(rng::AbstractRNG, deck::Deck)
    shuffle!(rng, deck.cards)
    return deck
end

shuffle(deck::Deck) = shuffle!(default_rng(), Deck(copy(deck.cards)))
shuffle(rng::AbstractRNG, deck::Deck) = shuffle!(rng, Deck(copy(deck.cards)))

include("masked_deck.jl")

end # module
