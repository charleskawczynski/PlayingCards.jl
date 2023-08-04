import StatsBase
const SB = StatsBase

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
    mask::BitVector # cards in deck
end
Base.length(deck::MaskedDeck) = count(deck.mask)
function MaskedDeck()
    cards = PlayingCards.full_deck()
    mask = BitVector(ntuple(_->true, 52))
    return MaskedDeck{typeof(cards)}(cards, mask)
end

Base.pop!(deck::MaskedDeck, n::Integer) = Base.pop!(deck, Val(n))

function Base.pop!(deck::MaskedDeck, ::Val{n})::NTuple{n,Card} where {n}
    return ntuple(i->Base.pop!(deck), Val(n))
end

function Base.pop!(deck::MaskedDeck)::Card
    i = findlast(1:52) do i
        @inbounds deck.mask[i]
    end
    @inbounds deck.mask[i] = false
    return @inbounds deck.cards[i]
end

function Base.popat!(deck::MaskedDeck, card::Card)::Card
    i = findfirst(c->c==card, deck.cards)
    @assert !isnothing(i)
    deck.mask[i] = false
    return deck.cards[i]
end

function restore!(deck::MaskedDeck, card::Card)
    i = findfirst(c->c==card, deck.cards)
    @assert !isnothing(i)
    @inbounds deck.mask[i] = true
    return nothing
end

SB.sample!(deck::MaskedDeck)::Card =
    SB.sample!(Random.default_rng(), deck)

function SB.sample!(rng, deck::MaskedDeck)::Card
    @assert any(deck.mask)
    @inbounds begin
        while true
            s = SB.sample(rng, 1:52)
            if deck.mask[s]
                deck.mask[s] = false
                return deck.cards[s]
            end
        end
    end
end

function Base.copyto!(x::MaskedDeck, y::MaskedDeck)
    x.cards .= y.cards
    x.mask .= y.mask
    x
end

function reset!(deck::MaskedDeck)
    deck.mask .= true
    return nothing
end

Random.shuffle!(deck::MaskedDeck) =
    Random.shuffle!(Random.default_rng(), deck)

function Random.shuffle!(rng, deck::MaskedDeck)
    reset!(deck)
    Random.shuffle!(rng, deck.cards)
    deck
end
