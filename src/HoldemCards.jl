module HoldemCards

using Random

import Base

export NumberCard, Jack, Queen, King, Ace
export Club, Spade, Heart, Diamond
export Card, Suit, Rank
export full_deck
export suit, value, rank_type
export ♣, ♠, ♡, ♢

export rank_list, rank

export Deck, shuffle!, OrderedDeck

#####
##### Types
#####

abstract type Suit end
struct Club <: Suit end
struct Spade <: Suit end
struct Heart <: Suit end
struct Diamond <: Suit end

const ♣ = Club()
const ♠ = Spade()
const ♡ = Heart()
const ♢ = Diamond()

abstract type Rank end
struct NumberCard{N} <: Rank end
struct Jack <: Rank end
struct Queen <: Rank end
struct King <: Rank end
struct Ace <: Rank end
NumberCard(n::Int) = NumberCard{n}()

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

Base.string(card::Card) = string(value(card.rank))*string(card.suit)
Base.string(r::NumberCard{N}) where {N}  = "$N"
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

value(r::Rank) = value(typeof(r))
value(::NumberCard{V}) where {V} = V
value(::Type{NumberCard{N}}) where {N} = N
value(::Type{Jack}) = 11
value(::Type{Queen}) = 12
value(::Type{King}) = 13
value(::Type{Ace}) = 14

low_value(::Type{T}) where {T} = value(T)
low_value(::Type{Ace}) = 1

rank_type(::Card{R,S}) where {R,S} = R
rank_type(::Type{Card{R,S}}) where {R,S} = R

value(c::Card) = value(c.rank)
rank(c::Card) = c.rank
suit(c::Card) = c.suit

#####
##### Lists
#####

const rank_list = (
    map(i->NumberCard{i}(), 2:10)...,
    Jack(), Queen(), King(),
    Ace(),
)

const rank_type_list_rev = typeof.(rank_list[end:-1:1])
const suit_list = (♣, ♠, ♡, ♢)
const FaceCards = (Jack(), Queen(), King(), Ace())
const FaceCardTypes = Union{typeof.(FaceCards)...}
const full_deck = [Card(r,s) for r in rank_list for s in suit_list]

#### Deck

struct Deck{C <: Vector}
    cards::C
end

Base.length(deck::Deck) = length(deck.cards)
Base.pop!(deck::Deck, n::Integer) = ntuple(i->pop!(deck.cards), n)

OrderedDeck() =
    Deck(Card[Card(r,s) for r in rank_list for s in suit_list])

function shuffle!(deck::Deck)
    deck.cards .= deck.cards[randperm(length(deck.cards))]
    nothing
end

end # module
