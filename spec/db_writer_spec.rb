require 'spec_helper'

writer = DbWriter.new

context 'Encapsulation check' do
  it 'should cause an error' do
    expect { writer.prepared_dat }.to raise_error(NoMethodError)
  end
end
