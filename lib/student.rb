require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(name:,grade:,id: nil)
    @id=id
    @name=name
    @grade=grade
  end

  def self.create_table
    query = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL
    DB[:conn].execute(query)
  end

  def self.drop_table
    query = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(query)
  end
  def save
    if self.id
    else
    query = <<-SQL
      INSERT INTO students (name,grade) VALUES (?,?)
    SQL
    DB[:conn].execute(query,self.name,self.grade)
    @id=DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end

  def self.create(name:,grade:)
    student=Student.new(name,grade)
    student.save
    student
  end


  def self.new_from_db(row)
    student=Student.new(name:row[:name],grade:row[:grade])
    student
  end

  def self.all
    query=<<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(query)
  end
  def self.find_by_name(name)
    all.find{
      |row|
      row[:name] = name
      new_from_db(row)
    }
  end

  def update
    query = <<-SQL
      UPDATE students SET name=?, grade=? WHERE id=?
    SQL
    DB[:conn].execute(query,self.name,self.grade,self.id)
  end



end
