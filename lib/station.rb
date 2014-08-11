require './lib/agent'

class Station < Agent
  attr_reader :name, :id, :table

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id]
    @table = "stations"
  end
end
