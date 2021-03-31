# Cards
using PlayingCards
card = A♡
string(card)
suit(A♡)
rank(A♠)
high_value(A♢)
high_value(J♣)
low_value(A♡)

# Deck
using PlayingCards
deck = ordered_deck()
shuffle!(deck)
hand = pop!(deck, 2)

for card in deck
  @show card
end
