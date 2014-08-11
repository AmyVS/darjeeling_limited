require './lib/agent'

class Train < Agent
  attr_accessor :name, :id, :table, :stations

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id].to_i
    @table = "trains"
    @stations = []
  end

  def assign_to(station)
    DB.exec("INSERT INTO stops (train_id, station_id) VALUES ('#{@id}', '#{station.id}') RETURNING id;")
  end

  def stations
    results = DB.exec("SELECT *
              FROM stations JOIN stops
              ON (stations.id = stops.station_id)
              WHERE (stops.train_id = #{@id})")
    results.each do |result|
      name = result['name']
      id = result['station_id']
      station = Station.new({:name => name, :id => id})
      @stations << station
    end
    @stations
  end

end
