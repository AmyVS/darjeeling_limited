require 'spec_helper'

describe Station do
  it 'initializes with a name' do
    test_station = Station.new({:name => 'New Delhi'})
    expect(test_station).to be_an_instance_of Station
    expect(test_station.name).to eq 'New Delhi'
  end

  it 'saves the station to the database' do
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    expect(Station.all).to eq [test_station]
  end

  it 'deletes the station from the database' do
    test_station1 = Station.new({:name => 'New Delhi'})
    test_station1.save
    test_station2 = Station.new({:name => 'Kashmir'})
    test_station2.save
    test_station1.delete
    expect(Station.all).to eq [test_station2]
  end

  it 'lists all stations in the table' do
    test_station1 = Station.new({:name => 'New Delhi'})
    test_station1.save
    test_station2 = Station.new({:name => 'Kashmir'})
    test_station2.save
    expect(Station.show_list).to eq ['1. New Delhi', '2. Kashmir']
  end

  it 'assigns a station to a train' do
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    test_station.assign_to(test_train)
    expect(test_train.stations).to eq [test_station]
  end

  it 'changes a station name' do
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    test_station.name = 'Mumbai'
    expect(test_station.name).to eq 'Mumbai'
  end

  it 'deletes the stop from the database' do
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    test_train1 = Train.new({:name => 'Oolong'})
    test_train2 = Train.new({:name => 'Chai'})
    test_train1.save
    test_train2.save
    test_train1.assign_to(test_station)
    test_train2.assign_to(test_station)
    test_station.delete_stop(test_train2.id)
    expect(test_station.trains).to eq [test_train1]
  end

end
