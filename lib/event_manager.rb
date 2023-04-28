# frozen_string_literal: true

puts 'Event Manager Initialized'

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
