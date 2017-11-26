require 'sequel'

# Output a tables of current connections to the DB
class DbAdapter
  # A complete database that can stored in most relational databases
  # requires the creation of a database
  # def self.connect
  #   @db = Sequel.postgres(
  #     host: 'localhost',
  #     user: 'username',
  #     password: 'password',
  #     database: 'exchange'
  #   )
  # end

  # Stored in RAM memory database, requires sqlite3
  # fast and easy way
  def self.connect
    @db = Sequel.sqlite
  end

  def self.dataset
    @db[:rate]
  end
end
