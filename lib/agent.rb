require 'rubygems'
require 'active_support/core_ext/string/inflections'

class Agent

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
    @id = save.first['id'].to_i
  end

  def == another_object
    self.name == another_object.name
  end

  def delete
    DB.exec("DELETE FROM #{self.table} WHERE id = #{self.id};")
    if self == Train
      DB.exec("DELETE FROM stops WHERE train_id = #{self.id};")
    elsif self == Station
      DB.exec("DELETE FROM stops WHERE station_id = #{self.id};")
    end
  end

  def self.show_list
    list = []
    self.all.each_with_index do |object, index|
      list << "#{index+1}. #{object.name}"
    end
    list
  end

  def delete_stop (other_id)
    if self.class == Station
      DB.exec("DELETE FROM stops WHERE train_id = #{other_id} AND station_id = #{self.id}")
    elsif self.class == Train
      DB.exec("DELETE FROM stops WHERE station_id = #{other_id} AND train_id = #{self.id}")
    end
  end

end
