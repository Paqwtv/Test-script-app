require 'sequel'

# Output a tables of current connections to the DB
class DbAdapter
  # A complete database that can stored in most relational databases
  # requires the creation of a database

  # def initialize
  #   @db = Sequel.postgres(
  #     host: 'localhost',
  #     user: 'postgres_hurum',
  #     password: 'password',
  #     database: 'exchange'
  #   )
  # end

  # Stored in RAM memory database, requires sqlite3
  # fast and easy way but the database is not saved locally

  def initialize
    @db = Sequel.sqlite
  end

  def get_table(table)
    table_exist?(table) ? cur_table(table) : make_table(table)
  end

  private

  def cur_table(table)
    @db[table]
  end

  def table_exist?(table)
    @db.table_exists?(table)
  end

  def make_table(table)
    @db.create_table table do
      primary_key :id
      Date :date, unique: true
      Float :course
    end
    cur_table(table)
  end
end
