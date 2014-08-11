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
end
