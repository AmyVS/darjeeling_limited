require './lib/train'
require './lib/station'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'darjeeling'})

@current_train = nil
@current_station = nil
@current_stop = nil

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
  user_choice = gets.chomp
  @current_train = Train.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid train. Please try again.\n\n"
  train_menu(:passenger)}

  @current_train.stations.each do |station|
    puts "#{station.name}"
  end

  case who
  when :passenger
    #do this
  when :conductor
    # conductor_options
    puts "Enter 'a' to add a station to this train line"
    puts "Enter 'r' to remove a station from this train line"
    puts "Enter any other key to go back to the main menu"
    user_choice = gets.chomp
    case user_choice
    when 'a'
      add_station
    when 'r'
      remove_stop
    else
      puts "Returning to the main menu"
      conductor_menu
    end
  end
end

def add_station
  puts "All Stations:"
  puts Station.show_list
  puts "Pick a station you'd like to assign #{@current_train.name} to."
  puts "Enter the number associated."
  user_choice = gets.chomp
  @current_station = Station.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid station. Please try again.\n\n"
  add_station }
  @current_train.assign_to(@current_station)

  puts "#{@current_station.name} has been added successfully to #{@current_train.name}. wOOt!"
  binding.pry
  puts "Would you like to add another? y/n"
  user_input = gets.chomp
  if user_input == 'y'
    add_station
  elsif user_input == 'n'
    conductor_menu
  else
    puts "Does not compute. Please try again."
    add_station
  end
end

def station_menu who

  puts "All Stations:"
  puts Station.show_list
  puts "Pick a station line to see which stations it stops at"
  puts "Enter the number for the station to look up:"

  user_choice = gets.chomp
  @current_station = Station.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid station. Please try again.\n\n"
  station_menu(who)}

  @current_station.trains.each do |train|
    puts "#{train.name}"
  end

  case who
  when :passenger
    #do this
  when :conductor
    #do this
  conductor_options
  end
end

def add_train
end

def remove_stop

  @current_stop.delete(train_id, station_id)

  # if calling from station_menu
  # @current_station is set already
  # list the trains that go through that station
  # have user pick the train they want to remove from the station

  # if calling from train_menu
  # @current_train is already set
  # list the stations that the train goes through
  # have user pick the station they want the train to skip

end

who_are_you
