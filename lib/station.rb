require './lib/agent'

class Station < Agent
  attr_reader :name, :id, :table

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id].to_i
    @table = "stations"
  end
end
