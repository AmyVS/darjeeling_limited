class Station
  attr_reader :name

  def initialize attributes
    @name = attributes[:name]
  end

  def save
    save = DB.exec("INSERT INTO stations (name) VALUES ('#{@name}') RETURNING id;")
    @id = save.first['id'].to_i
  end

  def == another_station
    self.name == another_station.name
  end

  def self.all
    results = DB.exec("SELECT * FROM stations;")
    stations = []
    results.each do |station|
      name = station['name']
      id = station['id']
      new_station = Station.new({:name => name})
      stations << new_station
    end
    stations
  end

end
