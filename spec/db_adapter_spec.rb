require 'spec_helper'

context 'Connecting to database' do
  it 'shold not to be nil' do
    expect(DbAdapter.connect).to be_truthy
  end
end
