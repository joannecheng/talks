require 'csv'

rows = CSV.open('wwc_responses.csv').read[1..-1]

counts = []

rows.each do |row|
  num_cups = row[5].to_i
  type = row[4]
  num_cups.times { counts << [row[4].to_s, row[0]] }
end

CSV.open('modified_responses.csv', 'wb') do |csv|
  counts.each { |count| csv << count }
end
