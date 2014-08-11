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

end
