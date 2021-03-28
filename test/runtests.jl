using Test
using HoldemCards
HC = HoldemCards

@testset "Suit" begin
    @test ♣ == HC.Club()
    @test ♠ == HC.Spade()
    @test ♡ == HC.Heart()
    @test ♢ == HC.Diamond()
    @test string(2♣) == "2♣"
    @test string(J♣) == "J♣"
    @test string(Q♣) == "Q♣"
    @test string(K♣) == "K♣"
    @test string(A♣) == "A♣"
    @test string(♣) == "♣"
    @test string(♠) == "♠"
    @test string(♡) == "♡"
    @test string(♢) == "♢"
end

@testset "Ranks" begin
    for r in 2:10
        @test value(HC.NumberCard{r}) == low_value(HC.NumberCard{r}) == r
    end
    @test value(HC.Jack)  == low_value(HC.Jack) == 11
    @test value(HC.Queen) == low_value(HC.Queen) == 12
    @test value(HC.King)  == low_value(HC.King) == 13
    @test value(HC.Ace) == 14
    @test low_value(HC.Ace) == 1

    for r in rank_list
        @test value(r) == value(typeof(r))
    end
end

@testset "Card" begin
    @test HC.rank_type(typeof(J♣)) == HC.Jack
    @test HC.rank_type(J♣) == HC.Jack
    @test HC.rank(J♣) == HC.Jack()
    @test HC.suit(J♣) == HC.Club()
    @test sprint(show, 2♣) == "2♣"
    @test sprint(show, J♣) == "J♣"

    @test value(J♣) == value(Jack)
end


@testset "Deck" begin
    deck = OrderedDeck()
    @test length(deck) == 52
    shuffle!(deck)
    cards = pop!(deck, 2)
    @test length(cards)==2
    @test length(deck)==50
end
