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
end
