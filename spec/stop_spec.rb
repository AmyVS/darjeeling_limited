require 'spec_helper'

describe Stop do

  it 'lists all stops in the table' do
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    test_train.assign_to(test_station)
    expect(Stop.show_list).to eq ['Oolong: New Delhi']
  end

  # it 'deletes a stop from the stops table' do
  #   test_train = Train.new({:name => 'Oolong'})
  #   test_train.save
  #   test_station = Station.new({:name => 'New Delhi'})
  #   test_station.save
  #   test_train.assign_to(test_station)
  #   test_station.assign_to(test_train)
  #   test_train.stations
  #   test_station.trains
  #   test_train.delete_stop
  #   test_station.delete_stop
  #   expect(test_station.trains).to eq []
  #   expect(test_train.stations).to eq []
  # end
end
