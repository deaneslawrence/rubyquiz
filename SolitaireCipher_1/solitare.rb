#!/usr/bin/env ruby
# Deck Class represents a deck of cards
class Deck
  
  CARDS = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  SUITS = ['C', 'D', 'H', 'S']
  
  def initialize (jokercount, ace = 'Low')
    deckSize = 52 + [2, jokercount].min
    @deck = (1..deckSize).to_a
  end
  
  # because its easier to work with a range of (1..52) + Jokers, 
  # that to work with card names (ie. 'Jack of Spades' or 'JS')
  # use translate for visual interfacing only
  def translate
    @tDeck = (0..@deck.count - 1).to_a
    for c in (0..@deck.count - 1) do
      if @deck[c] == "A" 
        @tDeck[c] = 'Joker1'
      else
        if @deck[c] == "B"
          @tDeck[c] = 'Joker2'
        else
          suit = SUITS[((@deck[c] - 1) / 13)]
          card = CARDS[((@deck[c] - 1) % 13)]
          #p(suit)
          #p(card)
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
  
  #1st card in deck is card 1, last card is card 54 (w/ 2 jokers)
  # count backward, if method returns -1 card is not in deck
  def findCard (card)
    d = @deck.count - 1
    while (card != @deck[d] and d >= 0)
      d = d - 1
    end
    return d
  end
  
  def cut(count)
    @deck = @deck[count, @deck.count - 1] + 
            @deck.first(count)
  end
            
  
  # order of cardOne and cardTwo are interchangeable
  def tripleCut (cardOne, cardTwo)
    cardOnePos = findCard (cardOne)
    cardTwoPos = findCard (cardTwo)
    if cardOnePos > cardTwoPos then
      cardOnePos, cardTwoPos = cardTwoPos, cardOnePos
    end
    @deck = @deck.last((@deck.count - 1) - cardTwoPos) +
            @deck[cardOnePos, cardTwoPos - cardOnePos + 1] +
            @deck.first(cardOnePos)
  end 
  
  def moveCard (card, pos)
    for a in (0..@deck.count - 1) do 
      if @deck[a] == card
        @deck.delete_at(a)
        # circular deck so establish insert position when it rolls over
        insertPos = a + pos
        if insertPos > @deck.count then
          insertPos = a + pos - @deck.count
        elsif insertPos < 0
          insertPos = @deck.count + insertPos
        end   
        @deck.insert(insertPos, card)
        break  #without break it will loop once again
      end
    end
  end
  
  def key
    # Move the A joker down one card. If the joker is at the bottom of the   
    # deck, move it to just below the first card. (Consider the deck to be 
    # circular.) The first time we do this, the deck will go from:

    # 1 2 3 ... 52 A B
    # To:
    # 1 2 3 ... 52 B A
    moveCard(53, 1)
    

    # Move the B joker down two cards. If the joker is the bottom card, 
    # move it just below the second card. If the joker is the just above the  
    # bottom card, move it below the top card. (Again, consider the deck to be 
    # circular.) This changes our example deck to:

    # 1 B 2 3 4 ... 52 A
    moveCard(54, 2)

    # Perform a triple cut around the two jokers. All cards above the top 
    # joker move to below the bottom joker and vice versa. The jokers and the 
    # cards between them do not move. This gives us:

    # B 2 3 4 ... 52 A 1
    tripleCut(53, 54)

    # Perform a count cut using the value of the bottom card. Cut the bottom 
    # card's value in cards off the top of the deck and reinsert them just 
    # above the bottom card. This changes our deck to:

    # 2 3 4 ... 52 A B 1 (the 1 tells us to move just the B)
    lastCard = @deck[@deck.count - 1]
    cut(lastCard)
    moveCard(lastCard, lastCard)
    
  end
  
  def outputLetter
    # skip jokers
    if @deck[[@deck[0], 53].min] <= 52 then
      card = (64 + (@deck[[@deck[0], 53].min] % 26)).chr
    else
      card = nil
    end
  end
    

    # Find the output letter. Convert the top card to it's value and count 
    # down that many cards from the top of the deck, with the top card itself 
    # being card number one. Look at the card immediately after your count and 
    # convert it to a letter. This is the next letter in the keystream. If the 
    # output card is a joker, no letter is generated this sequence. This step 
    # does not alter the deck. For our example, the output letter is:

    # D (the 2 tells us to count down to the 4, which is a D)

    # Return to step 2, if more letters are needed.

    # For the sake of testing, the first ten output letters for an unkeyed 
    # deck are:

    # D (4) W (49) J (10) Skip Joker (53) X (24) H (8)
    # Y (51) R (44) F (6) D (4) G (33)
    
  
  
end

d = Deck.new(2)

for b in (1..10) do
  d.key
  #d.reveal
  p(d.outputLetter)
end

# d.shuffle
# d.translate
d.reveal
