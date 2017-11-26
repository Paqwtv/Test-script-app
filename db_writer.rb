require_relative 'db_adapter'
require 'csv'
require 'open-uri'

# Load data and write to DB
class DbWriter
  RESOURCE_URL = 'https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'.freeze

  def initialize
    @database = DbAdapter.connect
    @table    = DbAdapter.dataset
  end

  def drop
    @database.drop_table(:rate)
    check_table
  end

  def check_table
    table_exist? ? check_for_update : make_table
  end

  private

  def table_exist?
    @database.table_exists?(:rate)
  end

  def prepared_data
    CSV.parse(open(RESOURCE_URL).drop(5).join)
  end

  def write_to_db
    puts 'Database is updating... please wait'
    t1 = Time.now
    begin
      prepared_data.map do |day, course|
        @table.insert(date: day, course: course) if course != '-'
      end
    rescue Sequel::UniqueConstraintViolation
      puts 'Database successfully updated'
    end
    t2 = Time.now
    puts "Recorded in #{(t2 - t1).round(3)} sec.",
         "Rows count: #{@table.count}"
  end

  def check_for_update
    first_date = prepared_data.first[0] # => "\"2017-11-23\""
    write_to_db if @table.where(date: first_date).get(:date).nil?
  end

  def make_table
    @database.create_table :rate do
      primary_key :id
      Date :date, unique: true
      Float :course
    end
    write_to_db
  end
end
