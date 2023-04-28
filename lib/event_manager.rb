# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_number(phone_number)
  # Remove all symbols from a phone number, including space.
  # Then, count the digits and check if the numbers are valid.
  phone_number = phone_number.tr('()-.', '').delete(' ')
  if phone_number.length == 10
    phone_number
  elsif phone_number.length == 11 && phone_number.start_with?('1')
    phone_number.slice(1, 10)
  end
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

# Take the user's registered date, create a new Time object with that information
# and push current hour to hours array
def add_hour(registered_date, hour)
  time = Time.strptime(registered_date, '%m/%d/%y %H:%M')

  hour.push(time.hour)
end

# Find hours with most occurances
def find_peak_hours(hours)
  hours.max_by { |hour| hours.count(hour) }
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
hours = []
contents.each do |row|
  id = row[0]
  name = row[:first_name]

  # Handling Bad and Good Zip Codes
  # Handling Missing Zip Codes
  zipcode = clean_zipcode(row[:zipcode])

  # Handle bad, good and missing phone numbers
  phone_number = clean_phone_number(row[:homephone])

  legislators = legislator_by_zipcode(zipcode)

  add_hour(row[:regdate], hours)

  form_letter = erb_template.result(binding)

  save_letter(id, form_letter)

  # puts phone_number
end

peak_hours = find_peak_hours(hours)
puts peak_hours
