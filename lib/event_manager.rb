# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislator_by_zipcode(zipcode)
  # Accessing the API
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  # Showing All Legislators in a Zip Code
  begin
    civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorLowerBody', 'legislatorUpperBody']
    ).officials
  rescue 
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'Event Manager Initialized'
puts ''

# Switching over to use the CSV Library
# Accessing Columns by their Names
contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

# Load our erb template
template_letter = File.read('form_letter.erb')
erb_template = ERB.new(template_letter)

# Displaying the Zip Codes of All Attendees
contents.each do |row|
  id = row[0]
  name = row[:first_name]

  # Handling Bad and Good Zip Codes
  # Handling Missing Zip Codes
  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislator_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_letter(id, form_letter)
end
