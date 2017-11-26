require_relative 'db_writer'
require 'date'

# exchanging using ECB rates
class Exchanger
  def self.exchange(amount, *dates)
    DbWriter.new.check_table
    Exchanger.num_error(amount) unless amount.is_a?(Numeric)
    @table = DbAdapter.dataset
    if dates.size > 1
      dates.map do |date|
        Exchanger.cur_rate(amount, date)
      end
    elsif dates.size == 1
      Exchanger.cur_rate(amount, dates)
    elsif dates.empty?
      Exchanger.arg_error
    end
  end

  def self.num_error(amount)
    raise ArgumentError.new("Only numbers are allowed,
     #{amount.inspect} is not a number")
  end

  def self.arg_error
    raise ArgumentError.new('No date in arguments')
  end

  def self.cur_rate(amount, date)
    day = PrepareDate.parse(date)
    rate = @table.where(date: day).get(:course)
    rate.nil? ? "Sorry, no data for #{day}" : (amount * rate.to_f).round(5)
  end
end

# extension of Date:Class functionality
class Date
  def self.yesterday
    Date.today - 1
  end
end

# prepare incoming Date
class PrepareDate
  def self.parse(date)
    Date.parse(date.to_s)
  end
end
