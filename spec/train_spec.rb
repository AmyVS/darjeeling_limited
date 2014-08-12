require 'spec_helper'

describe Train do
  it 'initializes with a name' do
    test_train = Train.new({:name => 'Oolong'})
    expect(test_train).to be_an_instance_of Train
    expect(test_train.name).to eq 'Oolong'
  end


  it 'saves the train to the database' do
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    expect(Train.all).to eq [test_train]
  end

  it 'deletes the train from the database' do
    test_train1 = Train.new({:name => 'Oolong'})
    test_train1.save
    test_train2 = Train.new({:name => 'Jasmine'})
    test_train2.save
    test_train1.delete
    expect(Train.all).to eq [test_train2]
  end

  it 'lists all trains in the table' do
    test_train1 = Train.new({:name => 'Oolong'})
    test_train1.save
    test_train2 = Train.new({:name => 'Jasmine'})
    test_train2.save
    expect(Train.show_list).to eq ['1. Oolong', '2. Jasmine']
  end

  it 'assigns a train to a station' do
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    test_train.assign_to(test_station)
    expect(test_station.trains).to eq [test_train]
  end

  it 'updates the train name' do
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    test_train.name = 'Chai'
    expect(test_train.name).to eq 'Chai'
  end

  it 'deletes the stop from the database' do
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    test_station1 = Station.new({:name => 'New Delhi'})
    test_station2 = Station.new({:name => 'Mumbai'})
    test_station1.save
    test_station2.save
    test_station1.assign_to(test_train)
    test_station2.assign_to(test_train)
    test_train.delete_stop(test_station2.id)
    expect(test_train.stations).to eq [test_station1]
  end

  it 'adds a train arrival time to a station' do
    test_station = Station.new({:name => 'New Delhi'})
    test_station.save
    test_train = Train.new({:name => 'Oolong'})
    test_train.save
    test_train.assign_to(test_station)
    test_train.set_time({:station_id => test_station.id, :time => '12:00:00'})
    binding.pry
    expect(test_train.time_at(test_station)).to eq '12:00:00'
  end
end
