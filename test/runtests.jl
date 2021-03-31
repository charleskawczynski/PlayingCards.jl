using Test
using PlayingCards

@testset "Suit" begin
    @test ♣ == Club()
    @test ♠ == Spade()
    @test ♡ == Heart()
    @test ♢ == Diamond()
end

@testset "Ranks" begin
    for v in 2:10
        @test NumberCard(v) == NumberCard{v}()
        @test value(NumberCard{v}) == low_value(NumberCard{v}) == v
    end
    @test value(Jack)  == low_value(Jack) == 11
    @test value(Queen) == low_value(Queen) == 12
    @test value(King)  == low_value(King) == 13
    @test value(Ace) == 14
    @test low_value(Ace) == 1
    @test low_value(A♠) == 1

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
    @test string(T♣) == "T♣"
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
    deck = ordered_deck()
    @test length(deck) == 52
    @test iterate(deck) == iterate(deck.cards)
    shuffle!(deck)
    cards = pop!(deck, 2)
    @test length(cards)==2
    @test length(deck)==50
    @test length(full_deck())==52

    @test sprint(show, ordered_deck()) == "2♣ 3♣ 4♣ 5♣ 6♣ 7♣ 8♣ 9♣ T♣ J♣ Q♣ K♣ A♣2♠ 3♠ 4♠ 5♠ 6♠ 7♠ 8♠ 9♠ T♠ J♠ Q♠ K♠ A♠2♡ 3♡ 4♡ 5♡ 6♡ 7♡ 8♡ 9♡ T♡ J♡ Q♡ K♡ A♡2♢ 3♢ 4♢ 5♢ 6♢ 7♢ 8♢ 9♢ T♢ J♢ Q♢ K♢ A♢"
end
