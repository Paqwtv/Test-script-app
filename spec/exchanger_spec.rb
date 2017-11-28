require 'spec_helper'

describe 'Processing exchange requests' do
  context 'for amount' do
    let(:query) { Exchanger.exchange(100, '2017-01-25') }
    let(:bad_query) { Exchanger.exchange('100', '2017-01-25') }
    let(:negative_query) { Exchanger.exchange(-100, '2017-01-25') }
    let(:zero_query) { Exchanger.exchange(-100, '2017-01-25') }

    it 'should raise ArgumentError when amount wrong type' do
      expect { bad_query }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when amount negative' do
      expect { negative_query }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when amount is zero' do
      expect { zero_query }.to raise_error(ArgumentError)
    end

    it 'should return Float type value' do
      expect(query.first).to be_a_kind_of(Float)
    end

    it 'should return a correct value' do
      expect(query).to eql([107.43])
    end
  end

  context 'for date' do
    let(:q_on_weekend) { Exchanger.exchange(100, '2017-01-01') }
    let(:dates) do
      [Date.today, '2000-4-9', Date.yesterday, Date.today - 111, '2017-01-25']
    end
    let(:q_for_dates) { Exchanger.exchange(100, *dates) }
    let(:q_data_empty) { Exchanger.exchange(100, nil) }

    it 'should return a text massage when they ask for a day off' do
      expect(q_on_weekend).to eql(['Sorry, no data for 2017-01-01'])
    end

    it 'should return a correct answer to the request of multiple dates' do
      expect(q_for_dates).to be_a_kind_of(Array)
    end

    it 'should return a correct answer to the request of multiple dates' do
      expect(q_for_dates.count).to eq(dates.count)
    end

    it 'should raise an error if no dates are transferred' do
      expect { q_data_empty }.to raise_error(ArgumentError)
    end
  end
end
