#!/usr/bin/env ruby
# Deck Class represents a deck of cards
class Deck
  
  CARDS = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  SUITS = ['C', 'D', 'H', 'S']
  
  def initialize (jokercount, ace = 'Low')
    @deck = (1..52).to_a
    if jokercount > 0
      @deck = @deck << 'A'
      if jokercount > 1
        @deck = @deck << 'B'
      end
    end
  end
  
  # because its easier to work with a range of (1..52) + Jokers, 
  # that to work with card names (ie. 'Jack of Spades' or 'JS')
  # use translate for visual interfacing only
  def translate
    @tDeck = (1..54).to_a
    for c in (0..@deck.count - 1) do
      if @deck[c] == "A" 
        @tDeck[c] = 'Joker1'
      else
        if @deck[c] == "B"
          @tDeck[c] = 'Joker2'
        else
          suit = SUITS[((@deck[c] - 1) / 13)]
          card = CARDS[((@deck[c] - 1) % 13)]
          @tDeck[c] = suit + card
        end
      end
    end
  end
  
  #very simple shuffle, a better shuffle is required for sensitive applications
  def shuffle
    @deck = @deck.sort_by{ rand }
  end
  
  def reveal
    p( @deck )
    p( @tDeck )
  end
  
end

d = Deck.new(2)
d.shuffle
d.translate
d.reveal
