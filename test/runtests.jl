using Test
using HoldemCards
HC = HoldemCards

@testset "Suit" begin
    @test ♣ == Club()
    @test ♠ == Spade()
    @test ♡ == Heart()
    @test ♢ == Diamond()
end

@testset "Ranks" begin
    @test NumberCard(1) == NumberCard{1}()
    for r in 2:10
        @test value(NumberCard{r}) == low_value(NumberCard{r}) == r
    end
    @test value(Jack)  == low_value(Jack) == 11
    @test value(Queen) == low_value(Queen) == 12
    @test value(King)  == low_value(King) == 13
    @test value(Ace) == 14
    @test low_value(Ace) == 1

    for r in rank_list()
        @test value(r) == value(typeof(r))
    end
end

@testset "Card" begin
    @test rank_type(typeof(J♣)) == Jack
    @test rank_type(J♣) == Jack
    @test rank(J♣) == Jack()
    @test suit(J♣) == Club()
    @test value(J♣) == value(Jack)
end

@testset "strings" begin
    @test sprint(show, 2♣) == "2♣"
    @test sprint(show, J♣) == "J♣"
    @test string(2♣) == "2♣"
    @test string(J♣) == "J♣"
    @test string(Q♣) == "Q♣"
    @test string(K♣) == "K♣"
    @test string(A♣) == "A♣"
    @test string(♣) == "♣"
    @test string(♠) == "♠"
    @test string(♡) == "♡"
    @test string(♢) == "♢"
    @test string(NumberCard{2}()) == "2"
end

@testset "Deck" begin
    deck = OrderedDeck()
    @test length(deck) == 52
    shuffle!(deck)
    cards = pop!(deck, 2)
    @test length(cards)==2
    @test length(deck)==50
    @test length(full_deck())==52
end
