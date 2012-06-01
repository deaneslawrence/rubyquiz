#!/usr/bin/env ruby

class SolitareEncryptor
  # SolitareEncryptor class implements the Solitaire encryption scheme
  # outined Neal Stephenson's "Cyryptonomicon".

  ASCII_BASE = 64
  
  def initialize (message, encryptOrDecrypt = "e")
    # convert message to uppercase and strip all non A-Z chars
    @message  = (message.upcase.split(%r{s*}).keep_if{|v| v =~ /[A-Z]/}).join
    @d = Deck.new(2)
    if encryptOrDecrypt.downcase.start_with?("e") then
      @enOrDe = 1
    else
      @enOrDe = -1
    end
  end
  
  def crypt
    @outMessage = ""
    @message.each_byte do |a|
      @d.key
      outCard = (ASCII_BASE + ((a - ASCII_BASE + 
        (@enOrDe * (nextCard - ASCII_BASE))) % 26)).chr
      # shift for Z
      outCard = "Z" if outCard == "@"
      @outMessage << outCard
    end
    return @outMessage
  end
    
  def nextCard
    # skip jokers
    if @d.deck[[@d.deck[0], 53].min] < 53 then
      card = (64 + (@d.deck[[@d.deck[0], 53].min] % 26))
      return card
    else
      # if joker rekey and try again
      @d.key
      nextCard
    end
  end
    
end


class Deck
  # Deck Class represents a deck of cards
  
  CARDS = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  SUITS = ['C', 'D', 'H', 'S']
  
  attr_reader :deck
  
  def initialize (jokercount, ace = 'Low')
    deckSize = 52 + [2, jokercount].min
    @deck = (1..deckSize).to_a
  end
  
  def translate
    # because its easier to work with a range of (1..52) + Jokers, 
    # that to work with card names (ie. 'Jack of Spades' or 'JS')
    # use translate for visual interfacing only
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
          @tDeck[c] = suit + card
        end
      end
    end
  end
  
  def shuffle
    # very simple shuffle, a better shuffle is required for sensitive  
    # applications
    @deck = @deck.sort_by{ rand }
  end
  
  def reveal
    p( @deck )
    p( @tDeck )
  end
  
  def findCard (card)
    # 1st card in deck is card 1, last card is card 54 (w/ 2 jokers)
    # count backward, if method returns -1 card is not in deck
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
end





# Get the message and whether to encrypt or decrypt 
message = ARGV[0]
encDirection = ARGV[1]

if message == nil then
  puts "You must specify a message to encrypt or decrypt"
else
  @encryptor = SolitaireEncryptor.new(message, encDirection)
  puts("Resulting message...")
  puts(@encryptor.crypt)
end


