# frozen_string_literal: true

require 'csv'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

puts 'Event Manager Initialized'
puts ''

=begin
# Read the File Contents
if File.exist?('event_attendees.csv')
  contents = File.read('event_attendees.csv')
  puts contents
  puts ''
else
  puts 'There is no such file.'
end

# Read the File Line By Line
lines = File.readlines('event_attendees.csv')
lines.each do |line|
  puts line
end
puts ''

# Display the First Names of All Attendees
lines.each do |line|
  columns = line.split(',')
  name = columns[2]
  puts name
end
puts ''

# Skipping the Header Row
lines.each_with_index do |line, index|
  next if index.zero?

  columns = line.split(',')
  name = columns[2]
  puts name
end
puts ''
=end

# Switching over to use the CSV Library
# Accessing Columns by their Names
contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

# Displaying the Zip Codes of All Attendees
contents.each do |row|
  name = row[:first_name]

  # Handling Bad and Good Zip Codes
  # Handling Missing Zip Codes
  zipcode = clean_zipcode(row[:zipcode])

  puts "#{name} #{zipcode}"
end
puts ''
