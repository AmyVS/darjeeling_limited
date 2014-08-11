require './lib/train'
require './lib/station'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'darjeeling'})

@current_train = nil
@current_station = nil

def who_are_you

  system("clear")

  puts "Welcome to the Darjeeling Limited. Are you a passenger or a train conductor?"
  puts "Press 'p' for passenger, or 'c' for conductor."
  user_input = gets.chomp

  if user_input == 'p'
    passenger_menu
  elsif user_input == 'c'
    conductor_menu
  else
    puts "\nInvalid input, please try again.\n"
    sleep(1)
    who_are_you
  end
end

def passenger_menu
  puts "\n\nWhich list would you like to refer to?"
  puts "Press 't' for trains, 's' for stations, or any other key to exit."
  user_input = gets.chomp

  if user_input == 't'
    train_menu(:passenger)
  elsif user_input == 's'
    station_menu(:passenger)
  else
    puts "\nSee you next time!"
    exit
  end
end

def conductor_menu
  puts "\n\nWhich list would you like to access?"
  puts "Press 't' for trains, 's' for stations, or any other key to exit."
  user_input = gets.chomp

  if user_input == 't'
    train_menu(:conductor)
  elsif user_input == 's'
    station_menu(:conductor)
  else
    puts "\nSee you next time!"
    exit
  end
end


def train_menu who

  puts "All Trains:"
  puts Train.show_list
  puts "Pick a train line to see which stations it stops at"
  puts "Enter the number for the train to look up:"

  case who

  when :passenger

    user_choice = gets.chomp
    @current_train = Train.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid train. Please try again.\n\n"
    train_menu(:passenger)}

    @current_train.stations.each do |station|
      puts "#{station.name}"
    end

  when :conductor

    user_choice = gets.chomp
    @current_train = Train.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid train. Please try again.\n\n"
    train_menu(:passenger)}

    @current_train.stations.each do |station|
      puts "#{station.name}"
    end

    conductor_menu

  end

end

def station_menu who



  puts "All Stations:"
  puts Station.show_list
  puts "Pick a station line to see which stations it stops at"
  puts "Enter the number for the station to look up:"

  case who

  when :passenger

    user_choice = gets.chomp
    @current_station = Station.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid station. Please try again.\n\n"
    station_menu(:passenger)}

    @current_station.trains.each do |train|
      puts "#{train.name}"
    end

  when :conductor

    user_choice = gets.chomp
    @current_station = Station.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid station. Please try again.\n\n"
    station_menu(:passenger)}

    @current_station.trains.each do |train|
      puts "#{train.name}"
    end

    conductor_menu

  end

end

who_are_you
