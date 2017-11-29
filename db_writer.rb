require_relative 'db_adapter'
require 'csv'
require 'open-uri'

# Load data and write to DB
class DbWriter
  RESOURCE_URL = 'https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'.freeze

  def initialize(table_name)
    @table_name = table_name
    @table      = DbAdapter.get_table(@table_name)
  end

  def table_processing
    if @table.empty?
      data = parsed_data.reverse
      write_db(data)
    else
      update?
    end
    @table
  end

  private

  def parsed_data
    CSV.parse(open(RESOURCE_URL).drop(5).join)
  end

  def update?
    current_csv_date = parsed_data.first[0]
    update if @table.where(date: current_csv_date).get(:date).nil?
  end

  def update
    current_db_date = @table.order(:date).last[:date].strftime
    data = []
    parsed_data.each do |elem|
      current_db_date.eql?(elem[0]) ? break : data.unshift(elem)
    end
    write_db(data)
  end

  def write_db(data)
    puts 'Database is updating...'
    t1 = Time.now
    data.map do |day, course|
      @table.insert(date: day, course: course) if course != '-'
    end
    t2 = Time.now
    puts "Recorded in #{(t2 - t1).round(3)} sec.",
         "Rows count: #{@table.count}"
  end
end
