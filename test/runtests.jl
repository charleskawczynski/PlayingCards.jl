using Test
using PlayingCards
using PlayingCards: rank_string

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
    @test_throws ArgumentError 0*♣
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
    @test_throws AssertionError rank_string(Int8(-1))
end

@testset "Deck" begin
    deck = ordered_deck()
    @test length(deck) == 52
    @test iterate(deck) == iterate(deck.cards)
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

@testset "Shuffle" begin
    deck = ordered_deck()
    deck_0 = ordered_deck()
    shuffle!(deck)
    @test !all(deck_0 .== deck)
    sort!(deck)
    @test all(deck_0 .== deck)
end

@testset "Cut / Riffle" begin
    deck = ordered_deck()
    cut!(deck, 13)
    cut!(deck, 39)
    @test deck.cards == full_deck()

    riffle!(deck)
    sort!(deck)
    @test deck.cards == full_deck()
end
