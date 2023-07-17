"""
    MaskedDeck()

A deck of cards (backed by a `Vector{Card}`)
that masks cards that have been removed via
`pop!`. Two variants of `pop!` are supported:

 - `pop!(::MaskedDeck)::Card`
 - `pop!(::MaskedDeck, ::Val{n})::NTuple{n,Card}`

Both methods are non-allocating and type-stable.
`pop!(::MaskedDeck, ::Card)` is not supported
however.

MaskedDeck also supports `reset!` which
makes all of the cards available again.
"""
struct MaskedDeck{T <: Vector} <: AbstractDeck
    cards::T
    len::Vector{Int}
end
Base.length(deck::MaskedDeck) = deck.len[1]
function MaskedDeck()
    cards = PlayingCards.full_deck()
    return MaskedDeck{typeof(cards)}(cards, Int[length(cards)])
end

Base.pop!(deck::MaskedDeck, n::Integer) = Base.pop!(deck, Val(n))

function Base.pop!(deck::MaskedDeck, ::Val{n})::NTuple{n,Card} where {n}
    return ntuple(i->Base.pop!(deck), Val(n))
end

function Base.pop!(deck::MaskedDeck)::Card
    @inbounds deck.len[1] -= 1
    return @inbounds deck.cards[deck.len[1]+1]
end

function reset!(deck::MaskedDeck)
    @inbounds deck.len[1] = length(deck.cards)
    return nothing
end

Random.shuffle!(deck::MaskedDeck) =
    Random.shuffle!(Random.default_rng(), deck)

function Random.shuffle!(rng, deck::MaskedDeck)
    reset!(deck)
    Random.shuffle!(rng, deck.cards)
    deck
end
