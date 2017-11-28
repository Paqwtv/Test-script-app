require_relative 'db_adapter'
require 'csv'
require 'open-uri'

# Load data and write to DB
class DbWriter
  RESOURCE_URL = 'https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'

  def initialize(table_name)
    @table_name = table_name
    @database   = DbAdapter.new
    @table      = @database.get_table(@table_name)
  end

  def table_processing
    first_date = parsed_data.first[0]
    write_to_db if @table.where(date: first_date).get(:date).nil?
    @table
  end

  private

  def parsed_data
    CSV.parse(open(RESOURCE_URL).drop(5).join)
  end

  def write_to_db
    puts 'Database is updating... please wait'
    t1 = Time.now
    begin
      parsed_data.map do |day, course|
        @table.insert(date: day, course: course) if course != '-'
      end
    rescue Sequel::UniqueConstraintViolation # review
      puts 'Database successfully updated'
    end
    t2 = Time.now
    puts "Recorded in #{(t2 - t1).round(3)} sec.",
         "Rows count: #{@table.count}"
  end
end
