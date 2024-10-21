require_relative '../Option'
require '../Project3/SDKs/CarmenSDK.rb'
require 'net/http'
require 'json'

# This code is run when option 1 is selected
private def option_1
  sdk = CarmenSDK.new()
  #Get course list and print them based on class grouping
  courseList = sdk.get_courses_favorites(false)
  courseList.each do |course|
      puts "Course: #{course['name']}"
      assignments = sdk.get_assignments(course['id'])

      #Print the assignment names
      assignNames = assignments.map {|ind| ind['name']}
      puts assignNames
  end


  url =  URI("http://worldtimeapi.org/api/timezone/America/New_York")

  #Make request
  response = Net::HTTP.get(url)

  # Parse JSON request
  time_data = JSON.parse(response)

  # Get the current time and print it
  current_time = time_data["datetime"]
  puts "Time when request was made: #{current_time}"

end

#What is put on console
$option1 = Option.new("Get assignment list (sorted by class) and next assignment due", -> {option_1})

def get_option_1
  $option1
end

