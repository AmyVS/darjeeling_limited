def who_are_you

  puts "Welcome to the Darjeeling Limited. Are you a passenger or a train conductor?"
  puts "Press 'p' for passenger, or 'c' for conductor."
  user_input = gets.chomp

  if user_input == 'p'
    passenger_menu
  elsif user_input == 'c'
    conductor_menu
  else
    puts "Invalid input, please try again."
    who_are_you
  end
end

def passenger_menu
  puts "Which list would you like to refer to?"
  puts "Press 't' for trains, 's' for stations, or any other key to exit."
  user_input = gets.chomp

  if user_input == 't'
    p_train_menu
  elsif user_input == 's'
    p_station_menu
  else
    puts "See you next time!"
    exit
  end
end

def conductor_menu
  puts "Which list would you like to access?"
  puts "Press 't' for trains, 's' for stations, or any other key to exit."
  user_input = gets.chomp

  if user_input == 't'
    c_train_menu
  elsif user_input == 's'
    c_station_menu
  else
    puts "See you next time!"
    exit
  end
end

who_are_you
