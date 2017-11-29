require_relative 'db_writer'
require 'date'

# exchanging using ECB rates
class Exchanger
  def self.exchange(amount, *dates)
    valid_params?(amount, *dates)
    table = DbWriter.new(:rate).table_processing
    dates.map do |date|
      exchange_for_date(table, amount, date)
    end
  end

  def self.valid_params?(amount, *dates)
    if !amount.is_a?(Numeric)
      raise_num_error(amount)
    elsif dates.empty?
      raise_arg_error
    end
  end

  def self.raise_num_error(amount)
    raise ArgumentError, "Only numbers are allowed,
                          #{amount.inspect} is not a number"
  end

  def self.raise_arg_error
    raise ArgumentError, 'No date in arguments'
  end

  def self.exchange_for_date(table, amount, date)
    day = Date.parse(date.to_s)
    rate = table.where(date: day).get(:course)
    rate.nil? ? nil : calculate_rate(amount, rate)
  end

  def self.calculate_rate(amount, rate)
    (amount * rate.to_f).round(5)
  end
end

# extension of Date:Class functionality
class Date
  def self.yesterday
    Date.today - 1
  end
end
