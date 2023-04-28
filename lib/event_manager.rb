# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislator_by_zipcode(zipcode)
  # Accessing the API
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  # Showing All Legislators in a Zip Code
  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorLowerBody', 'legislatorUpperBody']
    )
    legislators = legislators.officials
    # For Clean Display of Legislators
    legislator_names = legislators.map(&:name)
    legislator_names.join(', ')
  rescue 
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
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

  legislators = legislator_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
  puts ''
end
puts ''
