require 'rubygems'
require 'active_support/core_ext/string/inflections'

class Agent
  # def update


  # end
  def self.all
    table_name = self.to_s.downcase.pluralize
    results = DB.exec("SELECT * FROM #{table_name};")
    all_objects = []
    results.each do |object|
      name = object['name']
      id = object['id']
      new_object = self.new({:name => name, :id => id})
      all_objects << new_object
    end
    all_objects
  end

  def save
    save = DB.exec("INSERT INTO #{self.table} (name) VALUES ('#{self.name}') RETURNING id;")
    @id = save.first['id'].to_i #potential issue here
  end

  def == another_object
    self.name == another_object.name
  end

  def delete
    DB.exec("DELETE FROM #{self.table} WHERE id = #{self.id};")
  end

end
