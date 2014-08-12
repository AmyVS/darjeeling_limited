require 'rspec'
require 'pg'
require 'pry'

require 'train'
require 'station'

DB = PG.connect({:dbname => 'darjeeling_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec('DELETE FROM trains *;')
    DB.exec('DELETE FROM stations *;')
    DB.exec('DELETE FROM stops *;')
  end
end
