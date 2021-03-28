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
end

@testset "Ranks" begin
    for r in 2:10
        Tr = typeof(HC.NumberCard(r))
        @test HC.value(Tr) == HC.low_value(Tr) == r
    end
    r = HC.Jack();  Tr = typeof(r); @test HC.value(Tr) == HC.low_value(Tr) == 11
    r = HC.Queen(); Tr = typeof(r); @test HC.value(Tr) == HC.low_value(Tr) == 12
    r = HC.King();  Tr = typeof(r); @test HC.value(Tr) == HC.low_value(Tr) == 13

    r = HC.Ace()
    Tr = typeof(r)
    @test HC.value(Tr) == 14
    @test HC.low_value(Tr) == 1
end

@testset "Card" begin
    @test HC.rank_type(typeof(J♣)) == HC.Jack
    @test HC.rank_type(J♣) == HC.Jack
    @test HC.rank(J♣) == HC.Jack()
    @test HC.suit(J♣) == HC.Club()
    @test sprint(show, 2♣) == "2♣"
    @test sprint(show, J♣) == "J♣"
end


@testset "Deck" begin
    deck = OrderedDeck()
    @test length(deck) == 52
    shuffle!(deck)
    cards = pop!(deck, 2)
    @test length(cards)==2
    @test length(deck)==50
end
