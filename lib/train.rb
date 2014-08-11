require './lib/agent'

class Train < Agent
  attr_reader :name, :id, :table

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id].to_i
    @table = "trains"
  end

  def == another_train
    self.name == another_train.name
  end

end
