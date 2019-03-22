require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id != nil
      update_sql = <<-SQL
        UPDATE students SET name = (?), grade = (?) WHERE id = (?)
      SQL
      DB[:conn].execute(update, self.name, self.grade, self.id)
    else
      insert_sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(insert_sql, self.name, self.grade)
      id_sql = <<-SQL
          SELECT id FROM students WHERE name = (?) AND grade = (?)
      SQL
      self.id = DB[:conn].execute(id_sql, self.name, self.grade).flatten.first
    end
  end
end
