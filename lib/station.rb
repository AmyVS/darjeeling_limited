require './lib/agent'

class Station < Agent
  attr_reader :name, :id, :table, :trains

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id].to_i
    @table = "stations"
    @trains = []
  end

  def assign_to(train)
    DB.exec("INSERT INTO stops (station_id, train_id) VALUES ('#{@id}', '#{train.id}') RETURNING id;")
  end

  def trains
    results = DB.exec("SELECT *
              FROM trains JOIN stops
              ON (trains.id = stops.train_id)
              WHERE (stops.station_id = #{@id})")
    results.each do |result|
      name = result['name']
      id = result['train_id']
      train = Train.new({:name => name, :id => id})
      @trains << train
    end
    @trains
  end

end
