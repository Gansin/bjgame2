# Interactive command line blackjack game


def calculate_total(cards) 
  # [['3', 'H'], ['Q', 'S'], ... ]
  localarray = cards.map{|e| e[0] }  
# Go through cards array and pull out the card values and put into 
# an array called localarray

# Change pictures in cards to a number
# For each element in the local array
# if the card is an ace, give it a value of eleven
# if not an ace, test for picture. Changing pic to integer results in
# a zero.  If not zero then card is not a picture, the number becomes 
# the value
#
  total = 0
  localarray.each do |value|
    if value == "A"
      total += 11
    elsif value.to_i == 0 # J, Q, K
      total += 10
    else
      total += value.to_i
    end
  end

  #correct for Aces
  # Function to adjust a person’s hand to remain below 21
  #  because an ace can be a one or eleven.
  # How: Subtract 10 from the hand for every ace the person
  #   has until the total value is below 21
  #
  localarray.select{|e| e == "A"}.count.times do
    total -= 10 if total > 21
  end

  total
end


  


# Start Game

puts "Welcome to Blackjack!"
puts " "
game_on=0
p_bank = 500
p_bet = 0
while game_on == 0 || p_bank > 0
  puts "==========Beginning new game==================="
  puts "How much do you want to bet? enter zero to quit"
  puts "You have #{p_bank} dollars"

  p_bet=gets.chomp.to_i
  
  if p_bet == 0
    puts "You chose to bet nothing, it looks like you do not want to play, goodbye"
    game_on=1
    exit
  elsif 
    p_bet > p_bank
    puts "You do not have enough to bet that much"
    break
  else
    p_bank=p_bank-p_bet
  end

  suits = ['H', 'D', 'S', 'C']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  deck = cards.product(suits)
  deck.shuffle!
  deck
  # Deal Cards

  p_cards = []
  dealercards = []



  p_cards << deck.pop
  dealercards << deck.pop
  p_cards << deck.pop
  dealercards << deck.pop

  dealertotal = calculate_total(dealercards)
  p_cardsum = calculate_total(p_cards)

  # Show Cards

  puts ""
  puts "Dealer has: #{dealercards[0]} and #{dealercards[1]}, for a total of #{dealertotal}"
  puts "The Dealer is showing #{dealercards[1]}"
  puts "You have: #{p_cards[0]} and #{p_cards[1]}, for a total of: #{p_cardsum}"
  puts ""
  puts "You bet #{p_bet} and you have #{p_bank} total dollars" 


  # Player turn
  if p_cardsum == 21
    puts "Congratulations, you hit blackjack! You win!"
    busted=1
    p_bet=p_bet+(p_bet*2)
    p_bank=p_bank+p_bet
    #exit
  end
  doubled=1
  first_time_thru=0 # 0 is yes, first time
  while p_cardsum < 21 && doubled != 0
    puts "What would you like to do? 1) hit 2) stay 0) Double"
    busted=0
    hit_or_stay = gets.chomp
    doubled=hit_or_stay.to_i

    if !['0','1', '2'].include?(hit_or_stay)
      puts "Error: you must enter 0, 1 or 2"
      next
    end


    if doubled == 0
      hit_or_stay = "1"
      if first_time_thru != 0 
        
        puts "You can only double once per hand"
   #     exit
   #     break
        elsif
          first_time_thru = 1
        puts "You have #{p_bank} in the bank"
        puts "you had bet #{p_bet}"
        if p_bet > p_bank 
          puts "Sorry, you do not have enough to double"
  #        doubled=1
           break
        else 
          p_bank=p_bank-p_bet
          p_bet=p_bet*2
          doubled=0
          puts "Your bet is now #{p_bet} with #{p_bank} in the bank"
        end
       # break
      end
    end

    if hit_or_stay == "2"
      puts "You chose to stay."
      puts "Good luck sucker"
      puts "****"
      break
    end

    #hit
    new_card = deck.pop
    puts "Dealing card to player: #{new_card}"
    p_cards << new_card
    p_cardsum = calculate_total(p_cards)
    puts "Your total is now: #{p_cardsum}"

    if p_cardsum == 21
      puts "Congratulations, you hit blackjack! You win!"
      p_bet=p_bet*2
      p_bank=p_bank+p_bet
      puts "You won #{p_bet}"
      puts "You now have #{p_bank}"
      busted=1
    #  exit
      break
    elsif p_cardsum > 21
      puts "Sorry, it looks like you busted!"
      busted=1
      puts ""
      puts "You lost #{p_bet}"
      puts "You now have #{p_bank}"
      break
#      exit
    end
  end

  # Dealer’s turn

  if dealertotal == 21 && busted == 0
    puts "Sorry, dealer hit blackjack. You lose."
    puts "You lost #{p_bet}"
  #  p_bank=p_bank-p_bet
    puts "You now have #{p_bank}"
    busted=1
  #  break
   # exit
  end

  while dealertotal < 17 && busted == 0
    #hit=
    new_card = deck.pop
    puts "Dealing new card for dealer: #{new_card}"
    dealercards << new_card
    dealertotal = calculate_total(dealercards)
    puts "Dealer total is now: #{dealertotal}"

    if dealertotal == 21
      puts "Sorry, dealer hit blackjack. You lose."
      puts "You lost #{p_bet}"
      puts "You now have #{p_bank}"
      busted=1
      break
 #     exit
    elsif dealertotal > 21
      puts "Congratulations, dealer busted! You win!"
      puts "You won #{p_bet}"
      p_bank=p_bank+p_bet+p_bet
      puts "You now have #{p_bank}"
      busted=1
      break
#      exit

    end
  end

  # Compare hands

  puts "Dealer's cards: "
  dealercards.each do |card|
    puts "=> #{card}"
  end
  puts ""

  puts "Your cards:"
  p_cards.each do |card|
    puts "=> #{card}"
  end
  puts ""

  if (dealertotal <= 21 || p_cardsum <= 21) && busted == 0
    if dealertotal > p_cardsum
      puts "Sorry, dealer wins."
    #  p_bank=p_bank-p_bet
      puts "You lost #{p_bet}"
      puts "You now have #{p_bank}"
    elsif dealertotal < p_cardsum
      puts "Congratulations, you win!"
      puts "You won #{p_bet}"
      p_bank=p_bank+p_bet+p_bet
      puts "You now have #{p_bank}"
    else
      puts "It's a tie!"
      puts "You lucky dog, you got away this time"
      p_bank=p_bank+p_bet
      puts "You still have #{p_bank}"
    end
  end
busted=0
  if p_bank < 0 
    game_on=1
  end

#  exit
end
puts "Thank you for playing"
puts "You leave us with a bank of #{p_bank}"


