require './lib/agent'

class Train < Agent
  attr_reader :name, :id, :table

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id].to_i
    @table = "trains"
  end

  def assign_to(station)
    DB.exec("INSERT INTO stops (train_id, station_id) VALUES ('#{@id}', '#{station.id}') RETURNING id;")
  end
end
