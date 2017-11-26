require 'spec_helper'

query = Exchanger.exchange(100, '2017-01-25')
weekend = Exchanger.exchange(100, '2017-01-01')
dates = Exchanger.exchange(100, Date.today, '2000-4-9', Date.yesterday,
                           Date.today - 111, '2017-01-25')

context 'Processing exchange requests' do
  it 'should return a correct value' do
    expect(query).to eql(107.43)
  end

  it 'should return Float type value' do
    expect(query).to be_a_kind_of(Float)
  end

  it 'should return a text massage when they ask for a day off' do
    expect(weekend).to include('Sorry, no data for 2017-01-01')
  end

  it 'should return a correct answer to the request of multiple dates' do
    expect(dates).to be_truthy && be_a_kind_of(Array)
  end

  it 'should return an error if the amount is not a number' do
    expect { Exchanger.exchange('100', Date.today) }.to raise_error(ArgumentError)
  end

  it 'should return an error if no dates are transferred' do
    expect { Exchanger.exchange(100) }.to raise_error(ArgumentError)
  end
end
