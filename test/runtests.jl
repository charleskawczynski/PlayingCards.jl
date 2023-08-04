using Test
using StatsBase
const SB = StatsBase
using PlayingCards
const PC = PlayingCards
using PlayingCards: rank_string
using PlayingCards: MaskedDeck

using Random

rng = VERSION >= v"1.7.0" ? Random.Xoshiro(0x0451) : Random.MersenneTwister()

@testset "Ranks" begin
    for v in ranks()
        v==1 && continue
        @test high_value(v*♣) == low_value(v*♣) == v
    end
    @test low_value(1*♣) == 1
end

@testset "Color" begin
    @test color(J♣) == :black
    @test color(A♠) == :black
    @test color(♣) == :black
    @test color(♠) == :black
    @test color(J♢) == :red
    @test color(A♡) == :red
    @test color(♢) == :red
    @test color(♡) == :red
    @test color(🃏♡) == :red
    @test color(🃏♠) == :black
end

@testset "Card" begin
    @test rank(J♣) == 11
    @test suit(J♣) == ♣
    @test suit(J♡) == ♡
    @test suit(J♢) == ♢
    @test suit(J♠) == ♠
    @test suit(A♣) == ♣
    @test suit(A♡) == ♡
    @test suit(A♢) == ♢
    @test suit(A♠) == ♠
    @test_throws ArgumentError 14*♣
    @test_throws ArgumentError -1*♣
    @test suit(🃏♡) == ♡
end

@testset "strings" begin
    @test sprint(show, 2♣) == "2♣"
    @test sprint(show, J♣) == "J♣"
    @test string(2♣) == "2♣"
    @test string(T♣) == "T♣"
    @test string(J♣) == "J♣"
    @test string(Q♣) == "Q♣"
    @test string(K♣) == "K♣"
    @test string(A♣) == "A♣"
    @test string(♣) == "♣"
    @test string(♠) == "♠"
    @test string(♡) == "♡"
    @test string(♢) == "♢"
    @test string(🃏♡) == "🃏♡"
    @test_throws AssertionError rank_string(Int8(-1))
end

@testset "Deck" begin
    deck = ordered_deck()
    @test length(deck) == 52
    @test iterate(deck) == iterate(deck.cards)
    shuffle!(rng, deck)
    cards = pop!(deck, 2)
    @test length(cards)==2
    @test length(deck)==50
    @test length(full_deck())==52

    s="A♣ 2♣ 3♣ 4♣ 5♣ 6♣ 7♣ 8♣ 9♣ T♣ J♣ Q♣ K♣
A♠ 2♠ 3♠ 4♠ 5♠ 6♠ 7♠ 8♠ 9♠ T♠ J♠ Q♠ K♠
A♡ 2♡ 3♡ 4♡ 5♡ 6♡ 7♡ 8♡ 9♡ T♡ J♡ Q♡ K♡
A♢ 2♢ 3♢ 4♢ 5♢ 6♢ 7♢ 8♢ 9♢ T♢ J♢ Q♢ K♢
"
    @test sprint(show, ordered_deck()) == s

    deck = ordered_deck()
    five_spades = pop!(deck, 5♠)
    @test five_spades === 5♠
    @test length(deck) == 51
    @test findfirst(x->x==5♠, deck.cards) == nothing
    @test_throws ErrorException pop!(deck, 5♠)
end

@testset "Allocations" begin
    alloc = @allocated ordered_deck()
    if VERSION >= v"1.7.0"
        @test alloc == 352
    else
        @test alloc == 304
    end
end

@testset "MaskedDeck" begin
    deck = MaskedDeck()
    @test length(deck) == 52
    @test iterate(deck) == iterate(deck.cards)
    shuffle!(deck)
    cards = pop!(deck, Val(2))
    @test length(cards)==2
    @test length(deck)==50
    @test count(deck.mask)==50
    @test length(full_deck())==52

    # Test pop! correctness against regular deck
    mdeck = MaskedDeck()
    rdeck = ordered_deck()
    @test pop!(mdeck) == pop!(rdeck)[1]
    @test length(mdeck) == length(rdeck)
    @test pop!(mdeck) == pop!(rdeck)[1]
    @test length(mdeck) == length(rdeck)
    @test pop!(mdeck) == pop!(rdeck)[1]
    @test length(mdeck) == length(rdeck)

    @test pop!(mdeck, Val(3)) == pop!(rdeck, 3)
    @test length(mdeck) == length(rdeck)
    @test pop!(mdeck, Val(3)) == pop!(rdeck, 3)
    @test length(mdeck) == length(rdeck)

    # Allocations
    pop!(mdeck, Val(2))
    p_allocated = @allocated pop!(mdeck, Val(2))
    if VERSION ≥ v"1.7"
        @test p_allocated == 0
    end

    shuffle!(mdeck)
    p_allocated = @allocated shuffle!(mdeck)
    @test p_allocated == 0

    mdeck = MaskedDeck()
    c = SB.sample!(mdeck)
    @test count(mdeck.mask) == 51
end

@testset "More MaskedDeck" begin
    mdeck = MaskedDeck()
    c = Base.popat!(mdeck, A♡)
    @test mdeck.mask[findfirst(c->c==A♡, mdeck.cards)] == false
    PC.restore!(mdeck, A♡)
    @test count(mdeck.mask) == 52

    amdeck = MaskedDeck()
    bmdeck = MaskedDeck()
    Base.copyto!(amdeck, bmdeck)
    p_allocated = @allocated Base.copyto!(amdeck, bmdeck)
    @test p_allocated == 0
end
