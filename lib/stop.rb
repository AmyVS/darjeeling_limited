require './lib/agent'

class Stop < Agent

  attr_reader :stops, :train_id, :station_id

  def initialize attributes
    @train_id = attributes[:train_id]
    @station_id = attributes[:station_id]
    @table = 'stops'
  end

  def self.all
    results = DB.exec("SELECT * FROM stops;")
    all_stops = []
    results.each do |stop|
      id = stop['id']
      train_id = stop['train_id']
      station_id = stop['station_id']
      new_stop = Stop.new({:train_id => train_id, :station_id => station_id})
      all_stops << new_stop
    end
    all_stops
  end

  def self.show_list
    stops = []
    Stop.all.each do |stop|
      stops << "#{self.train_id}: #{self.station_id}"
    end
    stops
  end

end
