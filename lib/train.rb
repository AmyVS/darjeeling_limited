require './lib/agent'

class Train < Agent
  attr_reader :name, :id, :table

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id].to_i
    @table = "trains"
  end

  def save
    save = DB.exec("INSERT INTO trains (name) VALUES ('#{@name}') RETURNING id;")
    @id = save.first['id'].to_i
  end

  def == another_train
    self.name == another_train.name
  end

  def self.all
    results = DB.exec('SELECT * FROM trains;')
    trains = []
    results.each do |train|
      name = train['name']
      id = train['id']
      new_train = Train.new({:name => name, :id => id})
      trains << new_train
    end
    trains
  end

end
