require 'rspec'
require_relative '../convert_prices'

describe '#convert' do
  it 'converts csv into correct format' do
    converted = convert('home_prices_fixtures.csv')
    expect(converted).to eq converted_csv_str.strip
  end

  def converted_csv_str
    "region_name,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013
    Alabama,162983,181217,194017,,,"
  end
end
