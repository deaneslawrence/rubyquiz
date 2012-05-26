#!/usr/bin/env ruby
# Deck Class represents a deck of cards
class Deck
  
  def initialize (jokercount)
    @deck = (1..52).to_a
    if jokercount > 0
      @deck = @deck << 'A'
      if jokercount > 1
        @deck = @deck << 'B'
      end
    end
  end
  
  #very simple shuffle
  def shuffle
    @deck = @deck.sort_by{ rand }
  end
  
  def reveal
    p( @deck )
  end
  
end

d = Deck.new(2)
d.shuffle
d.reveal