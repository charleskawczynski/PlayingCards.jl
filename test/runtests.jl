using Test
using PlayingCards
using PlayingCards: rank_string

@testset "Suit" begin
    @test ♣ == Club()
    @test ♠ == Spade()
    @test ♡ == Heart()
    @test ♢ == Diamond()
end

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
    @test suit(J♣) == Club()
    @test_throws AssertionError 14*♣
    @test_throws AssertionError 0*♣
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
    @test_throws ErrorException rank_string(UInt8(0))
end

@testset "Deck" begin
    deck = ordered_deck()
    @test length(deck) == 52
    @test iterate(deck) == iterate(deck.cards)
    shuffle!(deck)
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
end
