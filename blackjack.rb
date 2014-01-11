class Deck
  
  @@deck = []
  
  def initialize(name)
    @game = name  
  end
  
  #returns 6 decks shuffled
  def new_deck
    suits = ['H', 'D', 'S', 'C']
    cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    
    #uses six decks
    @@deck = suits.product(cards)
    5.times { @@deck << suits.product(cards) } 
  end
  
  def deal_card
    @@deck.pop
  end
  
  def shuffle_deck
    @@deck.shuffle!
  end

end

module GamePlay
  def compare(dealertotal, playertotal)
    if dealertotal > playertotal
      puts "Sorry, dealer wins."
    elsif dealertotal < playertotal
      puts "Congratulations, you win!"
    else
      puts "It's a tie!"
    end
  end
end

class Player
  include GamePlay
  
  @@hand = []
  @@total = 0
  
  def initialize(name)
    @name = name
  end
  
  def hand
    @@hand
  end
  
  def total
    @@total
  end
  
  def first_deal(card_1, card_2)
    @@hand << card_1
    @@hand << card_2
    puts "#{@name} has #{card_1} and #{card_2}"
  end
  
  def calculate_total(cards) 
    arr = cards.map{|e| e[1] }
  
    total = 0
    arr.each do |value|
      if value == "A"
        total += 11
      elsif value.to_i == 0 # J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end
  
    #correct for Aces
    arr.select{|e| e == "A"}.count.times do
      total -= 10 if total > 21
    end
    
    total
  end
  
  def stand(total)
    "#{@name} stands with #{total}."
  end
  
  def hit(card)
    @@hand << card
    "#{@name} hits, card is #{card} you now have #{calculate_total(hand)}"
  end
  
end

class Dealer < Player
  include GamePlay
  
  @@delhand = []
  @@total = 0
  
  def initialize(name)
    @name = name
  end
  
  def first_deal(card_1, card_2)
    @@delhand << card_1
    @@delhand << card_2
    puts "#{@name} is showing #{card_1}."
  end
  
  def hit_or_stand(dealertotal)
    if dealertotal == 21
      puts "Sorry, dealer hit blackjack. You lose."
      exit
    end

    while dealertotal < 17
      #hit
      new_card = game_cards.deal_card
      puts "Dealing new card for dealer: #{new_card}"
      @@delhand << new_card
      dealertotal = dealer.calculate_total(dealer.hand)
      puts "Dealer total is now: #{dealertotal}"

      if dealertotal > 21
        puts "Congratulations, dealer busted! You win!"
        exit
      else 
        #compare using GamePlay module
        compare(dealer.calculate_total(dealer.hand),player_1.calculate_total(player_1.hand))
      end
    end
  end
end


game_cards = Deck.new('game_one')
game_cards.new_deck
game_cards.shuffle_deck
player_1 = Player.new("Garth")
player_1.first_deal(game_cards.deal_card, game_cards.deal_card)
playertotal = player_1.calculate_total(player_1.hand)
puts player_1.stand(playertotal)
#puts player_1.hit(game_cards.deal_card)
dealer = Dealer.new("Dealer")
dealer.first_deal(game_cards.deal_card, game_cards.deal_card)
dealertotal = dealer.calculate_total(dealer.hand)
puts dealertotal