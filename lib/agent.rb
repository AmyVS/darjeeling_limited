class Agent
  # def update

  # end


  def delete
    DB.exec("DELETE FROM #{self.table} WHERE id = #{self.id};")
  end

end
