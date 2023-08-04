var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"CurrentModule = PlayingCards","category":"page"},{"location":"api/#Card","page":"API","title":"Card","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Suit\nCard\nsuit\nrank\nhigh_value\nlow_value\ncolor","category":"page"},{"location":"api/#PlayingCards.Suit","page":"API","title":"PlayingCards.Suit","text":"Suit\n\nEncode a suit as a 2-bit value (low bits of a UInt8):\n\n0 = ♣ (clubs)\n1 = ♢ (diamonds)\n2 = ♡ (hearts)\n3 = ♠ (spades)\n\nSuits have global constant bindings: ♣, ♢, ♡, ♠.\n\n\n\n\n\n","category":"type"},{"location":"api/#PlayingCards.Card","page":"API","title":"PlayingCards.Card","text":"Card\n\nEncode a playing card as a 6-bit integer (low bits of a UInt8):\n\nlow bits represent rank from 0 to 15\nhigh bits represent suit (♣, ♢, ♡ or ♠)\n\nRanks are assigned as follows:\n\nnumbered cards (2 to 10) have rank equal to their number\njacks, queens and kings have ranks 11, 12 and 13\nthere are low and high aces with ranks 1 and 14, 0 is for Joker\nthere are low and high jokers with ranks 0 and 15\n\nThis allows any of the standard orderings of cards ranks to be achieved simply by choosing which aces to use.\n\nThere are a total of 64 possible card values with this scheme, represented by UInt8 values 0x00 through 0x3f.\n\n\n\n\n\n","category":"type"},{"location":"api/#PlayingCards.suit","page":"API","title":"PlayingCards.suit","text":"suit(::Card)\n\nThe suit of a card\n\n\n\n\n\n","category":"function"},{"location":"api/#PlayingCards.rank","page":"API","title":"PlayingCards.rank","text":"rank(::Card)\n\nThe rank of a card\n\n\n\n\n\n","category":"function"},{"location":"api/#PlayingCards.high_value","page":"API","title":"PlayingCards.high_value","text":"high_value(::Card)\nhigh_value(::Rank)\n\nThe high rank value. For example:\n\nRank(1) -> 14 (use low_value for the low Ace value.)\nRank(5) -> 5\n\n\n\n\n\n","category":"function"},{"location":"api/#PlayingCards.low_value","page":"API","title":"PlayingCards.low_value","text":"low_value(::Card)\nlow_value(::Rank)\n\nThe low rank value. For example:\n\nRank(1) -> 1 (use high_value for the high Ace value.)\nRank(5) -> 5\n\n\n\n\n\n","category":"function"},{"location":"api/#PlayingCards.color","page":"API","title":"PlayingCards.color","text":"color(::Card)\n\nA Symbol (:red, or :black) indicating the color of the suit or card.\n\n\n\n\n\n","category":"function"},{"location":"api/#Auxiliary-methods","page":"API","title":"Auxiliary methods","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"full_deck\nranks\nsuits","category":"page"},{"location":"api/#PlayingCards.full_deck","page":"API","title":"PlayingCards.full_deck","text":"full_deck\n\nA vector of a cards containing a full deck\n\n\n\n\n\n","category":"function"},{"location":"api/#PlayingCards.ranks","page":"API","title":"PlayingCards.ranks","text":"ranks\n\nA Tuple of ranks 1:13.\n\n\n\n\n\n","category":"function"},{"location":"api/#PlayingCards.suits","page":"API","title":"PlayingCards.suits","text":"suits\n\nA Tuple of all suits\n\n\n\n\n\n","category":"function"},{"location":"api/#Deck","page":"API","title":"Deck","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Deck\nordered_deck\npop!\nshuffle!","category":"page"},{"location":"api/#PlayingCards.Deck","page":"API","title":"PlayingCards.Deck","text":"Deck\n\nDeck of cards (backed by a Vector{Card})\n\n\n\n\n\n","category":"type"},{"location":"api/#PlayingCards.ordered_deck","page":"API","title":"PlayingCards.ordered_deck","text":"ordered_deck\n\nAn ordered Deck of cards.\n\n\n\n\n\n","category":"function"},{"location":"api/#Base.pop!","page":"API","title":"Base.pop!","text":"pop!(deck::Deck, n::Int = 1)\npop!(deck::Deck, card::Card)\n\nRemove n cards from the deck. or Remove card from the deck.\n\n\n\n\n\n","category":"function"},{"location":"api/#Random.shuffle!","page":"API","title":"Random.shuffle!","text":"shuffle!\n\nShuffle the deck! Optionally accepts an AbstractRNG to seed the shuffle.\n\n\n\n\n\n","category":"function"},{"location":"#PlayingCards.jl","page":"Home","title":"PlayingCards.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A package for representing playing cards for card games (for a standard deck of fifty two).","category":"page"},{"location":"#Cards","page":"Home","title":"Cards","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A playing Card is consists of a suit (♣,♠,♡,♢) and a rank:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Rank(N::Int) where 1 ≤ N ≤ 13 where\nN = 1 represents an Ace (which can have high or low values via high_value and low_value)\nN = 11 represents a Jack\nN = 12 represents a Queen\nN = 13 represents a King","category":"page"},{"location":"","page":"Home","title":"Home","text":"The value of the rank can be retrieved from high_value and low_value:","category":"page"},{"location":"","page":"Home","title":"Home","text":"high_value(c::Card) == low_value(c::Card) == c.rank\nhigh_value(::Card) = 14 for Ace\nlow_value(::Card) = 1 for Ace","category":"page"},{"location":"","page":"Home","title":"Home","text":"Cards have convenience constructors and methods for extracting information about them:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using PlayingCards\n@show card = A♡\n@show string(card)\n@show suit(A♡)\n@show rank(A♠)\n@show high_value(A♢)\n@show high_value(J♣)\n@show low_value(A♡)\nnothing","category":"page"},{"location":"#Decks","page":"Home","title":"Decks","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A Deck is a struct with a Vector of Cards, which has a few convenience methods:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using PlayingCards\n@show deck = ordered_deck()\n\nshuffle!(deck)\n\n@show hand = pop!(deck, 2)\n\n@show deck\nnothing","category":"page"}]
}