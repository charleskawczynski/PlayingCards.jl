using Random: randperm
import Random: shuffle!, shuffle

export shuffle!, shuffle
export riffle, riffle!, cut, cut!

Base.sort!(deck::Deck; kwargs...) = sort!(deck.cards; kwargs...,
    by = x->begin
        ClubVal = 100*(suit(x) isa Club)
        SpadeVal = 1000*(suit(x) isa Spade)
        HeartVal = 10000*(suit(x) isa Heart)
        DiamondVal = 100000*(suit(x) isa Diamond)
        val = high_value(x)+ClubVal+HeartVal+SpadeVal+DiamondVal
        val
    end)

Base.sort(deck::Deck; kwargs...) = sort(deck.cards; kwargs...,
    by = x->begin
        ClubVal = 100*(suit(x) isa Club)
        SpadeVal = 1000*(suit(x) isa Spade)
        HeartVal = 10000*(suit(x) isa Heart)
        DiamondVal = 100000*(suit(x) isa Diamond)
        val = high_value(x)+ClubVal+HeartVal+SpadeVal+DiamondVal
        val
    end)

"""
    shuffle!(cards::Vector)
    shuffle!(deck::Deck)

Shuffle the deck! `shuffle!` uses
`Random.randperm` to shuffle the deck.
"""
function shuffle!(cards::Vector)
    cards .= cards[randperm(length(cards))]
    nothing
end
shuffle!(deck::Deck) = shuffle!(deck.cards)

"""
    riffle!(cards::Vector)
    riffle!(deck::Deck)

Performs a riffle shuffle on the elements of
`cards` using the Gilbert-Shannon-Reed model.
"""
function riffle!(cards::Vector)
    vals = sort(rand(length(cards)))
    shift_vals = (2vals) .% 1
    cards .= cards[sortperm(shift_vals)]
    return nothing
end
riffle!(deck::Deck) = riffle!(deck.cards)

"""
    riffle(cards::Vector)
    riffle(deck::Deck)

Performs a riffle shuffle permutation on a deep copy of `cards` using the
Gilbert–Shannon–Reeds model. The original `Vector` of `cards` is unchanged.
"""
riffle(cards::Vector) = riffle!(deepcopy(cards))
riffle(deck::Deck) = riffle(deck.cards)


"""
    cut!(cards, idx = binom_rv(length(cards), 0.5))

Cuts the deck of `cards` by moving cards `1` through `idx`
(inclusive) to the back of the deck so the first card now
was formerly the one at position `idx+1`.

Cuts the deck at a random location. If the deck has `n`
cards, then the cut location is given by the binomial
random variable `B(n,1/2)`.
"""
function cut!(cards::Vector, idx::Int)
    n = length(cards)
    @assert 0 <= idx <= n "Cut index must be between 0 and $n [got $idx]"

    idx == 0 || idx == n && return

    A = cards[1:idx]
    B = cards[idx+1:end]

    na = length(A)
    nb = length(B)

    for j = 1:nb
        cards[j] = B[j]
    end

    for j = 1:na
        cards[nb+j] = A[j]
    end
    return nothing
end

simple_binomial(n::Int) = sum(rand() > 0.5 for _ = 1:n)

"""
    cut(cards, c = simple_binomial(length(cards)))

Performs a "cut" on `cards` at index `c`.
The result is that the first `c` elements
are moved to the end of the cards.

If `cards` has length `n` the location of
the cut is a binomial random variable `B(n,1/2)`.
"""
function cut!(cards::Vector, c::Int)
    cards .= vcat(cards[c+1:end], cards[1:c])
    return nothing
end
cut!(cards::Vector) = cut!(cards, simple_binomial(length(cards)))
cut!(deck::Deck, c::Int) = cut!(deck.cards, c)
cut!(deck::Deck) = cut!(deck.cards)

"""
    cut(cards, idx)
    cut(cards)

Uses [`cut!`](@ref) to cut a deep copy of the deck
`cards` leaving the original `cards` unchanged.
"""
cut(cards::Vector, c::Int) = cut!(deepcopy(cards), c)
cut(cards::Vector) = cut(cards, simple_binomial(length(cards)))
cut(deck::Deck, c::Int) = cut!(deck.cards, c)
cut(deck::Deck) = cut(deck.cards)
