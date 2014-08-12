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
    menu(:passenger)
  elsif user_input == 'c'
    menu(:conductor)
  else
    puts "\nInvalid input, please try again.\n"
    sleep(1)
    who_are_you
  end

end

def menu who
  @current_train = nil
  @current_station = nil

  puts "\n\nWhich list would you like to refer to?"
  puts "Press 't' for trains, 's' for stations, or any other key to exit."
  user_input = gets.chomp

  if user_input == 't'
    train_menu(who)
  elsif user_input == 's'
    station_menu(who)
  else
    puts "\nSee you next time!"
    exit
  end
end

def train_menu who

  puts "All Trains:"
  puts Train.show_list

  case who
  when :passenger
    puts "Pick a train line to see which stations it stops at"
    puts "Enter the number for the train to look up:"
    user_choice = gets.chomp
    @current_train = Train.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid train. Please try again.\n\n"
    train_menu(:passenger)}

    @current_train.stations.each_with_index do |station, index|
      puts "#{index+1}. #{station.name}"
    end

  when :conductor
    puts "Enter 'a' to add a new train line,"
    puts "Enter 'd' to delete an entire train line (use with caution!)."
    puts "Enter the train number to see which stations it stops at."
    user_choice = gets.chomp
    if user_choice.to_i == 0
      case user_choice
      when 'a'
        new_train
      when 'd'
        destroy_train
      else
        puts "Does not compute"
        train_menu(:conductor)
      end

    else
      @current_train = Train.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid train. Please try again.\n\n"
      train_menu(:passenger)}

      @current_train.stations.each_with_index do |station, index|
        puts "#{index+1}. #{station.name}"
      end

      puts "Enter 'a' to add a station to this train line"
      puts "Enter 'r' to remove a station from this train line"
      puts "Enter any other key to go back to the main menu"
      user_choice = gets.chomp
      case user_choice
      when 'a'
        add_station
      when 'r'
        remove_stop(:train)
      else
        puts "Returning to the main menu"
        menu(:conductor)
      end
    end
  end
end

def new_train
  puts "Type the name of the new train line:"
  input = gets.chomp
  new_train = Train.new({:name => input})
  new_train.save
  puts "You've successfully created the new train line #{new_train.name}."
  menu(:conductor)
end

def destroy_train
  Train.show_list
  puts "Enter the number of the train you want to destroy"
  input = gets.chomp
  @current_train = Train.all[(input.to_i)-1]
  puts "This will destroy #{@current_train.name} and all its stops. Are you sure? y/n"
  input = gets.chomp
  case input
  when 'y'
    puts "#{@current_train.name} has been successfully destroyed."
    @current_train.delete
    menu(:conductor)
  when 'n'
    puts "Whew, that was close"
    menu(:conductor)
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
  puts "Would you like to add another? y/n"
  user_input = gets.chomp
  if user_input == 'y'
    add_station
  elsif user_input == 'n'
    menu(:conductor)
  else
    puts "Does not compute. Please try again."
    add_station
  end
end

def station_menu who

  puts "All Stations:"
  puts Station.show_list

  case who
  when :passenger
    puts "Pick a station line to see which trains stop there."
    puts "Enter the number for the station to look up:"
    user_choice = gets.chomp
    @current_station = Station.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid station. Please try again.\n\n"
    station_menu(:passenger)}

    @current_station.trains.each_with_index do |train, index|
      puts "#{index+1}. #{train.name}"
    end

  when :conductor
    puts "Enter 'a' to add a new station."
    puts "Enter 'd' to delete an entire station (use with caution!)."
    puts "Enter the station number to see which trains stop there."

    user_choice = gets.chomp
    if user_choice.to_i == 0
      case user_choice
      when 'a'
        new_station
      when 'd'
        destroy_station
      else
        puts "Does not compute"
        station_menu(:conductor)
      end
    else
      @current_station = Station.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid station. Please try again.\n\n"
      station_menu(:conductor)}

      @current_station.trains.each_with_index do |train, index|
        puts "#{index+1}. #{train.name}"
      end
    end

    puts "Enter 'a' to add a train to this station."
    puts "Enter 'r' to remove a train from this station."
    puts "Enter any other key to go back to the main menu"
    user_choice = gets.chomp
    case user_choice
    when 'a'
      add_train
    when 'r'
      remove_stop(:station)
    else
      puts "Returning to the main menu"
      menu(:conductor)
    end
  end
end

def new_station
  puts "Type the name of the new station:"
  input = gets.chomp
  new_station = Station.new({:name => input})
  new_station.save
  puts "You've successfully created the new station #{new_station.name}."
  menu(:conductor)
end

def destroy_station
  Station.show_list
  puts "Enter the number of the station you want to destroy"
  input = gets.chomp
  @current_station = Station.all[(input.to_i)-1]
  puts "This will destroy #{@current_station.name} and all its stops. Are you sure? y/n"
  input = gets.chomp
  case input
  when 'y'
    puts "#{@current_station.name} has been successfully destroyed."
    @current_station.delete
    menu(:conductor)
  when 'n'
    puts "Whew, that was close"
    menu(:conductor)
  end
end

def add_train
  puts "All Trains:"
  puts Train.show_list
  puts "Pick a train you'd like to assign #{@current_station.name} to."
  puts "Enter the number associated."
  user_choice = gets.chomp
  @current_train = Train.all.fetch((user_choice.to_i)-1) { |i| puts "#{i+1} is not a valid train. Please try again.\n\n"
  add_train }
  @current_station.assign_to(@current_train)

  puts "#{@current_train.name} has been added successfully to #{@current_station.name}. wOOt!"
  puts "Would you like to add another? y/n"
  user_input = gets.chomp
  if user_input == 'y'
    add_train
  elsif user_input == 'n'
    menu(:conductor)
  else
    puts "Does not compute. Please try again."
    add_train
  end
end

def remove_stop which_menu
  case which_menu
  when :station
    puts "Which train would you like to remove from #{@current_station.name}?"
    puts "Enter the number from above."
    user_input = gets.chomp
    @current_train = @current_station.trains[(user_input.to_i)-1]
    binding.pry

    @current_station.delete_stop(@current_train.id)
    puts "#{@current_train.name} has been successfully removed from stop #{@current_station.name}."

  when :train
    puts "Which station would you like to remove from #{@current_train.name}?"
    puts "Enter the number from above."
    user_input = gets.chomp
    @current_station = @current_train.stations[(user_input.to_i)-1]
    binding.pry

    @current_train.delete_stop(@current_station.id)
    puts "#{@current_station.name} stop has been successfully removed from line #{@current_train.name}."
  end
  menu(:conductor)
end

who_are_you
